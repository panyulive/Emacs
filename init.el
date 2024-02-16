(require 'package)

;;=====================================================
;;      Init emacs defaults
;;=====================================================



;; HTTP 系のリポジトリ
;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(package-initialize) ; インストールx済みのElispを読み込む


;; 余計なファイルを生成させない
;(setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)

(setq backup-directory-alist '((".*" . "~/.emacs.d/back")))

;; 長いファイルを開く場合でも行番号を常に表示
(setq line-number-display-limit-width 100000)

;; C-x C-c で閉じる時に、ワンクッション置く
(setq confirm-kill-emacs 'y-or-n-p)

;;メニューバーを消す、ツールバーを消す
(menu-bar-mode -1)
(tool-bar-mode 0)

(setq default-directory "~/")
(setq command-line-default-directory "~/")


(tab-bar-mode 1)
(tab-bar-history-mode 1)

(defun my-tab-clone (&optional arg)
  (interactive "P")
  (let ((tab-bar-new-tab-choice t))
    (tab-new arg)))

(defun my-tab-select ()
  "Jump to any tab interactively. The purpose is to jump to tab number 10 or higher."
  (interactive)
  (tab-select
   (string-to-number (read-from-minibuffer "tab number: " "10"))))

(defun my-tab-select-last ()
  "Switch to the last tab."
  (interactive)
  (tab-select (length (funcall tab-bar-tabs-function))))

(setq tab-bar-new-tab-choice "*scratch*")
(setq tab-bar-new-tab-to 'rightmost)
(setq tab-bar-tab-hints t)
(setq tab-bar-tab-name-function #'tab-bar-tab-name-truncated)

;; 現在のタブを見やすくする
(face-spec-set 'tab-bar-tab '((((background light)) (:background "gold")) (((background dark)) (:background "orange"))))

;;=====================================================
;;      Init use-package.el
;;=====================================================
(require 'use-package)

(use-package doom-themes
    :custom
    (doom-themes-enable-italic t)
    (doom-themes-enable-bold t)
    :custom-face
    (doom-modeline-bar ((t (:background "#6272a4"))))
    :config
    (load-theme 'doom-bluloco-light t)
    (doom-themes-neotree-config)
    (doom-themes-org-config))

;; ++++++++++++++++++++++++++++
;; Qiita Companyからcorufへ移行するhttps://qiita.com/nobuyuki86/items/7c65456ad07b555dd67d
;; ++++++++++++++++++++++++++++

(use-package corfu
  :custom ((corfu-auto t)
           (corfu-auto-delay 0)
           (corfu-auto-prefix 1)
           (corfu-cycle t)
           (corfu-on-exact-match nil)
           (tab-always-indent 'complete))
  :init
  (global-corfu-mode +1)

  :config
  ;; java-mode などの一部のモードではタブに `c-indent-line-or-region` が割り当てられているので、
  ;; 補完が出るように `indent-for-tab-command` に置き換える
  (defun my/corfu-remap-tab-command ()
    (global-set-key [remap c-indent-line-or-region] #'indent-for-tab-command))
  (add-hook 'java-mode-hook #'my/corfu-remap-tab-command)

  ;; ミニバッファー上でverticoによる補完が行われない場合、corfuの補完が出るようにします。
  ;; https://github.com/minad/corfu#completing-in-the-minibuffer
  (defun corfu-enable-always-in-minibuffer ()
    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
    (unless (or (bound-and-true-p mct--active)
                (bound-and-true-p vertico--input))
      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
                  corfu-popupinfo-delay nil)
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1)

  ;; lsp-modeでcorfuが起動するように設定する
  (with-eval-after-load 'lsp-mode
    (setq lsp-completion-provider :none)))

;;error now 
(use-package tabnine
  :hook ((prog-mode . tabnine-mode)
         (text-mode . tabnine-mode)
         (kill-emacs . tabnine-kill-process))
  :bind (:map  tabnine-completion-map
	     ("TAB" . nil)
         ("<tab>" . nil))
  :init
  ;(tabnine-start-process)
  (global-tabnine-mode +1))

(use-package cape
  :hook (((prog-mode
           text-mode
           conf-mode
           eglot-managed-mode
           lsp-completion-mode) . my/set-super-capf))
  :config
  (setq cape-dabbrev-check-other-buffers nil)

  (defun my/set-super-capf (&optional arg)
    (setq-local completion-at-point-functions
                (list (cape-capf-noninterruptible
                       (cape-capf-buster
                        (cape-capf-properties
                         (cape-capf-super
                          (if arg
                              arg
                            (car completion-at-point-functions))
                          #'tempel-complete
                          #'tabnine-completion-at-point
                          #'cape-dabbrev
                          #'cape-file)
                         :sort t
                         :exclusive 'no))))))

  (add-to-list 'completion-at-point-functions #'tempel-complete)
  (add-to-list 'completion-at-point-functions #'tabnine-completion-at-point)
  (add-to-list 'completion-at-point-functions #'cape-file t)
  (add-to-list 'completion-at-point-functions #'cape-tex t)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev t)
  (add-to-list 'completion-at-point-functions #'cape-keyword t))

(use-package orderless
    :init
    (setq completion-styles '(orderless basic)
          completion-category-defaults nil
          completion-category-overrides nil)

    :config
    ;; migemoでローマ字検索を有効にする
    (with-eval-after-load 'migemo
      (defun orderless-migemo (component)
        (let ((pattern (downcase (migemo-get-pattern component))))
          (condition-case nil
              (progn (string-match-p pattern "") pattern)
            (invalid-regexp nil))))
      (add-to-list 'orderless-matching-styles 'orderless-migemo))

    ;; corfuはorderless-flexで絞り込む
    (with-eval-after-load 'corfu
      (add-hook 'corfu-mode-hook
                (lambda ()
                  (setq-local orderless-matching-styles '(orderless-flex))))))

 (use-package prescient
    :config
    (setq prescient-aggressive-file-save t)
    (prescient-persist-mode +1))

;(use-package corfu-prescient
;    :after corfu
;    :config
;    (with-eval-after-load 'orderless
;      (setq corfu-prescient-enable-filtering nil))
;    (corfu-prescient-mode +1))

(use-package kind-icon
  :after corfu
  :custom (kind-icon-default-face 'corfu-default) ; to compute blended backgrounds correctly
  :config
(add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; error now
(use-package corfu-popupinfo
  :straight nil
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode))

;;error now 
(use-package yasnippet
    :bind (nil
           :map yas-keymap
           ("<tab>" . nil)
           ("TAB" . nil)
           ("<backtab>" . nil)
           ("S-TAB" . nil)
           ("M-}" . yas-next-field-or-maybe-expand)
           ("M-{" . yas-prev-field))
    :init
    (yas-global-mode +1))

 (use-package tempel
    :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
           ("M-*" . tempel-insert)))

;;=====================================================
;;      Init leaf.el
;;=====================================================
(require 'leaf)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(tabnine all-the-icons yasnippet cape corfu kind-icon lsp-mode orderless prescient tempel use-package neotree modus-themes leaf doom-themes)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
