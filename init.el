

;;; early-init.el --- Early Initialization. -*- lexical-binding: t; no-byte-compile: t -*-
;;; Commentary:
;;
;; Emacs 27+ introduces early-init.el, which is run before init.el,
;; before package and UI initialization happens.
;;
;;; Code:
(require 'package)

;;=====================================================
;;      Init emacs defaults
;;=====================================================



;; HTTP 系のリポジトリ
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ;; ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("org" . "https://orgmode.org/elpa/")
        ("gnu" . "https://elpa.gnu.org/packages/")))

(package-initialize) ; インストールx済みのElispを読み込む


;; 余計なファイルを生成させない
;(setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)

(setq backup-directory-alist '((".*" . "~/.emacs.d/back")))

(prefer-coding-system 'utf-8)

(setq-default indent-tabs-mode)

;; 長いファイルを開く場合でも行番号を常に表示
(setq line-number-display-limit-width 100000)

;; C-x C-c で閉じる時に、ワンクッション置く
(setq confirm-kill-emacs 'y-or-n-p)

;;メニューバーを消す、ツールバーを消す
(menu-bar-mode -1)
(tool-bar-mode 0)

(setq default-directory "~/")
(setq command-line-default-directory "~/")

(setq tab-always-indent 'complete)

;emacs標準のペア入力 20241005smartparentaへ移行してみる
;(electric-pair-mode t)

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
(face-spec-set 'tab-bar-tab '((((background light)) (:background "gold")) (((background dark)) (:background "silver"))))

(cua-mode t)

;;=====================================================
;;      Init leaf.el
;;=====================================================

(require 'leaf)

(require 'leaf-convert)
(require 'leaf-tree)
(require 'el-get)
(require 'hydra)
(require 'key-combo)
(require 'smartrep)
(require 'key-chord)
(require 'diminish)
(require 'delight)

(leaf leaf-keywords
  :ensure t
  :config
  (leaf-keywords-init)
  )

(leaf magit
  :bind (("C-x g". magit-status)
	 ("C-x M-g" . magit-dispatch-popup))
  :config
  )

;;=============================================================================
;; cmigemo設定.migemo
;; OS側のPATHを設定済みの前提.
;;=============================================================================
(when (executable-find "cmigemo")
  (defvar migemo-dictionary nil)
  (setq migemo-dictionary
        (cond ((eq system-type 'windows-nt) (concat (file-name-directory (executable-find "cmigemo")) "dict/utf-8/migemo-dict"))
              ((eq system-type 'gnu/linux)  "/usr/share/cmigemo/utf-8/migemo-dict")))
  (when (file-exists-p migemo-dictionary)
    (require 'migemo)
    (defvar migemo-command)
    (defvar migemo-options)
    (defvar migemo-coding-system)
    (setq migemo-command "cmigemo")
    (setq migemo-options '("-q" "-e"))
    (setq migemo-coding-system 'utf-8-unix)))

(leaf ivy-migemo
  :config
  )

;(leaf smartparens
;  :ensure t
;  :require t
;  :config
;   (smartparens-global-mode t)  ;; グローバルにsmartparensモードを有効化
;   (sp-local-pair 'web-mode "'" "'")  ;; Web-modeでシングルクォートのペアを設定
;   (sp-local-pair 'ruby-mode "'" "'") ;; Ruby-modeでシングルクォートのペアを設定
;   :hook
;   ((web-mode . smartparens-mode)  
;    (ruby-mode . smartparens-mode))
;   )

(leaf vertico
  :ensure t
  :global-minor-mode t
  :bind
  ((:vertico-map
    ("C-z" . vertico-insert)
    ("C-l" . grugrut/up-dir)))
  :preface
  (defun grugrut/up-dir ()
    "ひとつ上のディレクトリ階層に移動する."
    (interactive)
    (let* ((orig (minibuffer-contents))
	   (orig-dir (file-name-directory orig))
	   (up-dir (if orig-dir (file-name-directory (directory-file-name orig-dir))))
	   (target (if (and up-dir orig-dir) up-dir orig)))
      (delete-minibuffer-contents)
      (insert target)))
  :custom
  (vertico-count . 20)
  (vertico-cycle . t))
 
 
(leaf corfu
  :ensure t
  :global-minor-mode t
  :custom
  (corfu-cycle . t)
  (corfu-auto . t)
  (corfu-auto-delay . 0)
  (corfu-auto-prefix . 1)
  (tab-always-indent 'complete)
  (text-mode-inspell-word-compleation . nil)
  :init
  (global-corfu-mode t)
  :config
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

  (with-eval-after-load 'lsp-mode
    (setq lsp-completion-providor :none))
  )


(leaf corfu-popupinfo
  :after corfu
  )
 
(require 'orderless)
(leaf orderless
  :ensure t
  :custom
  (completion-styles . '(orderless))
  :config
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
                  (setq-local orderless-matching-styles '(orderless-flex)))))
    )

(require 'prescient)
(leaf prescient
  :ensure t 
  ;:global-minor-mode t
  :config
  (setq prescient-aggressive-file-save t)
  (prescient-persist-mode t)
  )

(require 'corfu-prescient)
(leaf corfu-prescient
  :ensure t
  :config
  
  (corfu-prescient-mode t)
  )

(leaf cape
  :ensure t)
 
(leaf flymake
  :global-minor-mode t)
 
(leaf project
  :custom
  (project--vc-merge-submodules . nil))

(leaf puni
  :doc "ペア入力用のアプリケーション"
  :config
  (puni-global-mode t))

(leaf editorconfig
  :global-minor-mode t)
 
(leaf goggles
  :doc "変更箇所を強調する"
  :ensure t 
  :diminish t
  :hook prog-mode-hook text-mode-hook
  :custom
  ;; 色を薄くする回数、1で即消える
  (goggles-pulse-iterations . 10)
  ;; 色を薄くする1回ごとの秒数
  (goggles-pulse-delay . 0.2)

  :custom-face
  
  )



;(leaf consult
;  :ensure t
;  :bind
;  (([remap switch-to-buffer] . consult-buffer)
;   ([remap goto-line] . consult-goto-line)
;   ([remap yank-pop] . consult-yank-pop)
;   ("C-;" . consult-buffer))
; 
;  )
; 
;(leaf embark
;  :ensure t
;  :config
;  (leaf embark-consult
;    :ensure t
;    :after consult))
; 
;(leaf recentf
;  :init
;  (recentf-mode)
;  :config
;  (setopt recentf-max-saved-items 5000)
;  (setopt recentf-auto-cleanup 'never))

;;=====================================================
;;      Init use-package.el
;;=====================================================
(require 'use-package)

(use-package doom-themes
  :custom
  (doom-themes-enable-italic t)
  (doom-themes-enable-bold t)
   :custom-face
					;(doom-modeline-bar ((t (:background "#6272a4"))))
   :config
   (load-theme 'doom-one t)
   (doom-themes-neotree-config)
   (doom-themes-org-config)
   
   )
 
 (use-package doom-modeline
   :ensure t
   :init (doom-modeline-mode 1))
 
 (add-hook 'go-mode-hook
	  (lambda ()
	    (setq-default)
	    (setq tab-width 4)
	    (setq standard-indent 4)
	    (setq indent-tabs-mode nil)))





 
;; ++++++++++++++++++++++++++++
;; Qiita Companyからcorufへ移行するhttps://qiita.com/nobuyuki86/items/7c65456ad07b555dd67d
;; ++++++++++++++++++++++++++++

;; eglot(LSP)
;'(use-package eglot
;'  :ensure t
;'  :hook
;'  (c++-mode . eglot-ensure)
;'  (sh-mode . eglot-ensure)
;'  (python-mode . eglot-ensure)
;'  (html-mode . eglot-ensure)
;'  (cmake-mode . eglot-ensure)
;'  (bitbake-mode . eglot-ensure)
;'  :config(
;'  (add-to-list 'eglot-server-programs '((bitbake-mode) "bitbake-language-server"))
;'  (add-to-list 'eglot-server-programs '(ruby-mode . ("solargraph" "socket" "--port" "0")))
;'  (add-hook 'ruby-mode-hook 'eglot-ensure))
;'  :bind (("M-t" . xref-find-definitions)
;'     ("M-r" . xref-find-references)
;'     ("C-t" . xref-go-back)))


(use-package elgot

  :hook
  (ruby-mode . elgot-ensure)


  )
  

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language
 
;; optional if you want which-key integration
(use-package which-key
    :config
    (which-key-mode))

;(use-package corfu
;  :custom ((corfu-auto t)
;           (corfu-auto-delay 0)
;           (corfu-auto-prefix 1)
;           (corfu-cycle t)
;           (corfu-on-exact-match nil)
;           (tab-always-indent 'complete))
;  :init
;  (global-corfu-mode +1)
;  
;  :config
;  ;; java-mode などの一部のモードではタブに `c-indent-line-or-region` が割り当てられているので、
;  ;; 補完が出るように `indent-for-tab-command` に置き換える
;  (defun my/corfu-remap-tab-command ()
;    (global-set-key [remap c-indent-line-or-region] #'indent-for-tab-command))
;  (add-hook 'java-mode-hook #'my/corfu-remap-tab-command)
; 
;  ;; ミニバッファー上でverticoによる補完が行われない場合、corfuの補完が出るようにします。
;  ;; https://github.com/minad/corfu#completing-in-the-minibuffer
;  (defun corfu-enable-always-in-minibuffer ()
;    "Enable Corfu in the minibuffer if Vertico/Mct are not active."
;    (unless (or (bound-and-true-p mct--active)
;                (bound-and-true-p vertico--input))
;      ;; (setq-local corfu-auto nil) ;; Enable/disable auto completion
;      (setq-local corfu-echo-delay nil ;; Disable automatic echo and popup
;                  corfu-popupinfo-delay nil)
;      (corfu-mode 1)))
;  (add-hook 'minibuffer-setup-hook #'corfu-enable-always-in-minibuffer 1)
; 
;  ;; lsp-modeでcorfuが起動するように設定する
;  (with-eval-after-load 'lsp-mode
;    (setq lsp-completion-provider :none)))
; 
;;error now 
;(use-package cape
;  :hook (((prog-mode
;           text-mode
;           conf-mode
;           eglot-managed-mode
;           lsp-completion-mode) . my/set-super-capf))
;  :config
;  (setq cape-dabbrev-check-other-buffers nil)
; 
;  (defun my/set-super-capf (&optional arg)
;    (setq-local completion-at-point-functions
;                (list (cape-capf-noninterruptible
;                       (cape-capf-buster
;                        (cape-capf-properties
;                         (cape-capf-super
;                          (if arg
;                              arg
;                            (car completion-at-point-functions))
;                          #'tempel-complete
;                          #'cape-dabbrev
;                          #'cape-file)
;                         :sort t
;                         :exclusive 'no))))))
; 
;  (add-to-list 'completion-at-point-functions #'tempel-complete)
;  (add-to-list 'completion-at-point-functions #'cape-file t)
;  (add-to-list 'completion-at-point-functions #'cape-tex t)
;  (add-to-list 'completion-at-point-functions #'cape-dabbrev t)
;  (add-to-list 'completion-at-point-functions #'cape-keyword t))
; 
;(use-package orderless
;    :init
;    (setq completion-styles '(orderless basic)
;          completion-category-defaults nil
;          completion-category-overrides nil)
; 
;    :config
    
    
; 
;    ;; corfuはorderless-flexで絞り込む
;    (with-eval-after-load 'corfu
;      (add-hook 'corfu-mode-hook
;                (lambda ()
;                  (setq-local orderless-matching-styles '(orderless-flex))))))
; 
; (use-package prescient
;    :config
;    (setq prescient-aggressive-file-save t)
;    (prescient-persist-mode +1))

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

(use-package nerd-icons
  :config
  )

;; error now
;(use-package corfu-popupinfo
;  ;:straight nil
;  :after corfu
;  :hook (corfu-mode . corfu-popupinfo-mode))
 
;;error now 
(use-package yasnippet
  :after corfu
  :bind (nil
         :map yas-keymap
         ("<tab>" . nil)
         ("TAB" . nil)
         ("<backtab>" . nil)
         ("S-TAB" . nil)
         )
  :init
  :config
  (yas-global-mode t)
  
  )
 
 (use-package tempel
    :bind (("M-+" . tempel-complete) ;; Alternative tempel-expand
           ("M-*" . tempel-insert)))

(use-package web-mode
  :ensure t
  :mode ("\\.html?\\'" "\\.erb\\'" "\\.ejs\\'" "\\.css\\'" "\\.scss\\'")
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t)
  (setq web-mode-tag-auto-close-style 2)
  (setq web-mode-enable-auto-expanding t))

(use-package undo-fu
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z")   'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

(use-package undo-fu-session
  :config
  (undo-fu-session-global-mode 1)
  )

(use-package vundo
  :config
  (with-eval-after-load 'meow
    (meow-leader-define-key
     '("u" . vundo))))

(use-package swiper
  :ensure t
  :config
  (defun isearch-forward-or-swiper (use-swiper)
    (interactive "p")
    ;; (interactive "P") ;; 大文字のPだと，C-u C-sでないと効かない
    (let (current-prefix-arg)
      (call-interactively (if use-swiper 'swiper 'isearch-forward))))
  (global-set-key (kbd "C-s") 'isearch-forward-or-swiper)
  )

(use-package ivy
  :ensure t
  ;; :config
  ;; (fset 'ivy--regex 'identity)
  )

;(use-package copilot
;  :ensure t
;  :config
;  )

(use-package direx
  :config
  )

(use-package llm-ollama
  :config
  (setopt ellama-language "Japanese")
  (setopt ellama-naming-scheme 'ellama-generate-name-by-llm)
  (setopt ellama-provider (make-llm-ollama
			   :chat-model "llama3.1"
			   :embedding-model "llama3.1"))
  (setopt ellama-translation-provider (make-llm-ollama
				       :chat-model "aya"
				       :embedding-model "aya"))

  (setopt ellama-providers
	  '(("llama3.1" . (make-llm-ollama
			   :chat-model "llama3.1"
			   :embedding-model "llama3.1"))
	    ("aya" . (make-llm-ollama
		      :chat-model "aya"
		      :embedding-model "aya"))

	    ))
	  
  )

;; shell plugin 
(use-package mistty
  :config
  )

(use-package json-mode 
  :config 
  (add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))
  )

(use-package origami
  :config
  (add-hook 'json-mode-hook 'origami-mode)
  )

(use-package js2-mode
  :ensure t
  :mode (("\\.js\\'". js2-mode)
	 ("\\.jsx\\'". js2-jsx-mode))
  :config
  (setq js2-basic-offset 2)
  (setq js2-indent-level 2)
  (setq js2-mode-show-parse-errors t)
  (setq js2-mode-show-strict-warnings t)
  )

(use-package js2-refactor
  :ensure t
  :hook (js2-mode . js2-refactor-mode)
  :config 
  (js2r-add-keybindings-with-prefix "C-c C-m")
  )

(use-package visual-regexp
  :ensure t
  :bind (
	 ("M-%" . vr/replace))
  :config
					;(vr/replace)
					;(vr/query-replace)


  )

;(use-package meow
;  :config
;  (setq meow-use-clipboard t
;        meow-expand-hint-counts nil)
;  
;  (defun meow-setup ()
;    (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
;    (meow-motion-overwrite-define-key
;     '("p" . meow-next)
;     '("n" . meow-prev)
;     '("<escape>" . ignore))
;    (meow-leader-define-key
;     ;; SPC j/k will run the original command in MOTION state.
;     '("p" . "H-p")
;     '("n" . "H-n")
;     ;; Use SPC (0-9) for digit arguments.
;     '("0" . delete-window)
;     '("1" . delete-other-windows)
;     '("2" . split-window-below)
;     '("3" . split-window-right)
;     '("4" . switch-to-buffer-other-frame)
;     '("5" . meow-digit-argument)
;     '("6" . meow-digit-argument)
;     '("7" . meow-digit-argument)
;     '("8" . meow-digit-argument)
;     '("9" . meow-digit-argument)
;     '("/" . meow-keypad-describe-key)
;     '("?" . meow-cheatsheet)
;     '("w" . other-window)
;     '("s" . ("search" . ,search-map))
;     '("p" . ("project" . ,project-prefix-map))
;     '("t" . ("toggle" . ,my-toggle-map))
;     '("q" . ("quit" . ,my-quit-map)))
;    (meow-normal-define-key
;     '("$" . move-end-of-line)
;     '("0" . move-beginning-of-line)
;     '("^" . back-to-indentation)
;     '("9" . meow-expand-9)
;     '("8" . meow-expand-8)
;     '("7" . meow-expand-7)
;     '("6" . meow-expand-6)
;     '("5" . meow-expand-5)
;     '("4" . meow-expand-4)
;     '("3" . meow-expand-3)
;     '("2" . meow-expand-2)
;     '("1" . meow-expand-1)
;     '("-" . negative-argument)
;     '(";" . repeat)
;     '(":" . meow-reverse)
;     '("," . meow-inner-of-thing)
;     '("." . meow-bounds-of-thing)
;     '("<" . meow-beginning-of-thing)
;     '(">" . meow-end-of-thing)
;     '("[" . scroll-down-command)
;     '("]" . scroll-up-command)
;     '("{" . backward-paragraph)
;     '("}" . forward-paragraph)
;     '("a" . meow-append)
;     '("A" . meow-open-below)
;     '("b" . meow-back-word)
;     '("B" . meow-back-symbol)
;     '("c" . meow-change)
;     '("k" . meow-kill)
;     '("K" . meow-kill-whole-line)
;     '("e" . meow-next-word)
;     '("E" . meow-next-symbol)
;     '("f" . meow-find)
;     '("g" . meow-cancel-selection)
;     '("G" . meow-grab)
;;     '("h" . meow-left)
;;     '("H" . meow-left-expand)
;     '("i" . meow-insert)
;     '("I" . meow-open-above)
;;     '("j" . meow-next)
;;     '("J" . meow-next-expand)
;;     '("k" . meow-prev)
;;     '("K" . meow-prev-expand)
;;     '("l" . meow-right)
;;     '("L" . meow-right-expand)
;     '("m" . meow-join)
;     '("o" . meow-block)
;     '("O" . meow-to-block)
;     '("y" . yank)
;     '("q" . meow-quit)
;     '("Q" . meow-goto-line)
;     '("r" . meow-replace)
;     '("R" . meow-swap-grab)
;;     '("s" . meow-change)
;     '("t" . meow-till)
;     '("u" . meow-undo)
;     '("U" . meow-undo-in-selection)
;     '("v" . set-mark-command)
;     '("V" . meow-line)
;     '("w" . meow-mark-word)
;     '("W" . meow-mark-symbol)
;     '("x" . meow-delete)
;     '("y" . meow-save)
;     '("Y" . meow-sync-grab)
;     '("z" . meow-pop-selection)
;     '("'" . meow-reverse)
;     '("/" . isearch-forward)
;     '("s" . isearch-repeat-forward)
;     '("S" . isearch-repeat-backward)
;     '("*" . isearch-forward-symbol-at-point)
;     '("=" . indent-region)
;     '("<escape>" . ignore)))
; 
;  (meow-setup)
;  (meow-global-mode +1)
; 
;  ;; ノーマルモードに戻る際、日本語入力を解除する
;  (add-hook 'meow-normal-mode-hook #'deactivate-input-method)
;  )


;;====================================================
;;      Original.el
;;====================================================


(defun move-to-next-multiple-of-10 ()
  "Move the cursor to the next multiple of 10."
  (interactive)
  (let ((current-pos (point))
        (found nil))
    (while (and (not found) (re-search-forward "[0-9]+" nil t))
      (let ((num (string-to-number (match-string 0))))
        (when (= 0 (mod num 10))
          (goto-char (match-beginning 0))
          (setq found t))))
    (unless found
      (goto-char current-pos)
      (message "No more multiples of 10 found."))))


;;====================================================
;;      Develop.el
;;====================================================



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("88f7ee5594021c60a4a6a1c275614103de8c1435d6d08cc58882f920e0cec65e" default))
 '(package-selected-packages
   '(corfu-prescient smart-tabs-mode ivy-migemo mozc vertico eglot elgot smartparens leaf-tree leaf-convert puni meow visual-regexp js2-refactor js2-mode origami json-mode mistty nerd-icons-ivy-rich direx counsel editorconfig ## copilot swiper undo-fu undo-fu-session vundo nerd-icons-dired nerd-icons-corfu doom-modeline tabnine dap-mode which-key go-mode go web-mode all-the-icons yasnippet cape corfu kind-icon lsp-mode orderless prescient tempel use-package neotree modus-themes leaf doom-themes))
 '(tab-bar-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Hack" :foundry "outline" :slant normal :weight regular :height 102 :width normal)))))


(provide 'early-init)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; early-init.el ends here
