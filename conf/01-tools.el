(eval-when-compile
  (require 'use-package))
  (require 'bind-key)

(use-package open-junk-file
  :config
  (setq open-junk-file-format "~/.emacs.d/junk/%Y/%m/%Y-%m-%d-%H%M%S.")
  
  )

(use-package undo-tree
  :config
  (global-set-key (kbd "C--") 'undo-tree-undo)
  (global-set-key (kbd "C-=") 'undo-tree-redo)
  
  (global-set-key (kbd "C-x u") 'undo-tree-mode)
  )

;(use-package undohist
;  :ensure t
;  :config
;  (setq undohist-ignored-files '("/tmp" "COMMIT_EDITMSG"))
;  (undohist-initialize)
;  )



(use-package shell-pop
  :bind (("C-:" . shell-pop))
  :init
   (setq shell-pop-shell-type '("eshell" "*eshell*" (lambda () (eshell))))
  
  :config


  (add-hook 'eshell-mode-hook
            '(lambda()
               (progn
                 (define-key eshell-mode-map (kbd "C-f") 'find-file-other-window)
                 ;;(define-key eshell-mode-map (kbd "<left>"))
                 )))
  
  )

(use-package highlight-symbol
  :bind
  ("C-c C-h" . highlight-symbol)
  
  :config
  (bind-key "C-c C-n" 'highlight-symbol-next highlight-symbol-mode)
  (bind-key "C-c C-p" 'highlight-symbol-prev highlight-symbol-mode)
  (bind-key "C-c M-%" 'highlight-symbol-query-replace highlight-symbol-mode)
  
  )

(use-package company
  :config
 
  ;(global-company-mode)
  
  ;; 自動補完を offにしたい場合は, company-idle-delayを nilに設定する
  ;; auto-completeでいうところの ac-auto-start にあたる.
  (custom-set-variables
   '(company-idle-delay nil))
  
  (set-face-attribute 'company-tooltip nil
                      :foreground "black" :background "lightgrey")
  (set-face-attribute 'company-tooltip-common nil
                      :foreground "black" :background "lightgrey")
  (set-face-attribute 'company-tooltip-common-selection nil
                      :foreground "white" :background "steelblue")
  (set-face-attribute 'company-tooltip-selection nil
                      :foreground "black" :background "steelblue")
  (set-face-attribute 'company-preview-common nil
                      :background nil :foreground "lightgrey" :underline t)
  (set-face-attribute 'company-scrollbar-fg nil
                      :background "orange")
  (set-face-attribute 'company-scrollbar-bg nil
                      :background "gray40")
 
  (global-set-key (kbd "C-M-i") 'company-complete)
 
  ;; C-n, C-pで補完候補を次/前の候補を選択
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-search-map (kbd "C-n") 'company-select-next)
  (define-key company-search-map (kbd "C-p") 'company-select-previous)
 
  ;; C-sで絞り込む
  (define-key company-active-map (kbd "C-s") 'company-filter-candidates)
 
  ;; TABで候補を設定
  (define-key company-active-map (kbd "C-i") 'company-complete-selection)
 
  ;; 各種メジャーモードでも C-M-iで company-modeの補完を使う
  (define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete)
 
  (require 'company-quickhelp)
  (company-quickhelp-mode +1)

  (require 'company-php)
  (add-hook 'php-mode-hook 'company-mode)
  )

(use-package auto-complete
  :init
  (require 'auto-complete-config)
  (require 'yasnippet)
  (require 'fuzzy)
  
  :config
  (global-auto-complete-mode nil)
  (ac-config-default)
  
  (setq ac-use-menu-map t)
  (setq ac-use-fuzzy t)
  (setq ac-use-comphist t)
  (setq ac-quick-help-delay 0.5)
  ;(bind-key "return" 'nil ac-menu-map)
  ;(bind-key "return" 'nil ac-completing-map)
  ;(bind-key  "C-j" 'ac-expand ac-completing-map)
  
  )


(use-package gtags
  :config
  
  )

(eval-after-load 'eshell
  '(require 'eshell-z nil t))

(use-package smartparens
  :config
  (smartparens-global-mode t)
  (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
  
  )

(use-package zop-to-char
  :bind
  ("M-z" . zop-up-to-char)
  :config
  )

;コードリーディング支援　コメント挿入
(use-package annotate
  :init
  (setq annotate-file "~/.emacs.d/annotations")
  :config
  (defun annotate-editing-text-property (&rest them)
    (let ((bmp (buffer-modified-p))
          (inhibit-read-only t))
      (apply them)
      (set-buffer-modified-p bmp)))
  (advice-add 'annotate-change-annotation :around 'annotate-editing-text-property)
  (advice-add 'annotate-create-annotation :around 'annotate-editing-text-property)
;;; 規約違反なキーバインドを矯正
  (define-key annotate-mode-map (kbd "C-c C-a") nil)
  (define-key annotate-mode-map (kbd "C-c a") 'annotate-annotate)
                                       ;
  ;色変更
  (set-face-foreground 'annotate-annotation "brack")
  (set-face-background 'annotate-annotation "yellow")

  (setq annotate-use-messages nil)
;;; 常に使えるようにする
  (add-hook 'find-file-hook 'annotate-mode)
  )

(use-package magit
  :commands (magit-status)
  :config
  ;;magit Congig 
 )

(use-package howm
  :bind (("C-c , ," . howm-menu))
  :init
  ;;howm Config
  (setq howm-menu-lang 'ja)
  ;; howm directoryの場所
  (setq howm-directory "~/Dropbox/emacs/howm/")
  
  :config
  (mapc
   (lambda (f)
     (autoload f
       "howm" "Hitori Otegaru Wiki Modoki" t))
   '(howm-menu howm-list-all howm-list-recent
               howm-list-grep howm-create
               howm-keyword-to-kill-ring))
  
  (defun howm-save-buffer-and-kill ()
    "howmメモを保存と同時に閉じます。"
    (interactive)
    (when (and (buffer-file-name)
               (string-match "\\.txt" (buffer-file-name)))
      (save-buffer)
      (kill-buffer nil)))
  
  ;; C-c C-cでメモの保存と同時にバッファを閉じる
  (define-key howm-mode-map (kbd "C-c C-c") 'howm-save-buffer-and-kill)
  
  )



;;タブの状態永続化
;;(require 'elscreen-persist)

;;(elscreen-persist-mode t)




;;タブの設定に[X]を表示しない
(setq elscreen-tab-display-kill-screen nil)
;;header-lineに[<->]を表示しない
(setq elscreen-tab-display-control t)

(defmacro elscreen-create-automatically (ad-do-it)
  `(if (not (elscreen-one-screen-p))
       ,ad-do-it
     (elscreen-create)
     (elscreen-notify-screen-modification 'force-immediately)
     (elscreen-message "New screen is automatically created")))

(defadvice elscreen-next (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

(defadvice elscreen-previous (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

(defadvice elscreen-toggle (around elscreen-create-automatically activate)
  (elscreen-create-automatically ad-do-it))

;; タブ移動を簡単に
(global-set-key (kbd "C-t") 'elscreen-next)
(add-hook 'dired-mode-hook '
          (lambda ()
            (global-set-key (kbd "C-t") 'elscreen-next)))

(defun my:elscreen-current-directory ()
  (let* (current-dir
         (active-file-name
          (with-current-buffer
              (let* ((current-screen (car (elscreen-get-conf-list 'screen-history)))
                     (property (cadr (assoc current-screen
                                            (elscreen-get-conf-list 'screen-property)))))
                (marker-buffer (nth 2 property)))
            (progn
              (setq current-dir (expand-file-name (cadr (split-string (pwd)))))
              (buffer-file-name)))))
    (if active-file-name
        (file-name-directory active-file-name)
      current-dir)))
(defun my:non-elscreen-current-directory ()
  (let* (current-dir
         (current-buffer
          (nth 1 (assoc 'buffer-list
                        (nth 1 (nth 1 (current-frame-configuration))))))
         (active-file-name
          (with-current-buffer current-buffer
            (progn
              (setq current-dir (expand-file-name (cadr (split-string (pwd)))))
              (buffer-file-name)))))
    (if active-file-name
        (file-name-directory active-file-name)
      current-dir)))

(use-package powerline
  :config
  (setq ns-use-srgb-colorspace nil)
  (powerline-default-theme)
  
  )

;; Window 分割を画面サイズに従って計算する
(defun split-window-vertically-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-vertically)
    (progn
      (split-window-vertically
       (- (window-height) (/ (window-height) num_wins)))
      (split-window-vertically-n (- num_wins 1)))))
(defun split-window-horizontally-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-horizontally)
    (progn
      (split-window-horizontally
       (- (window-width) (/ (window-width) num_wins)))
      (split-window-horizontally-n (- num_wins 1)))))
 
;; Window 分割・移動を C-t で
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (if (>= (window-body-width) 270)
        (split-window-horizontally-n 3)
      (split-window-horizontally)))
  (other-window 1))
(global-set-key (kbd "C-o") 'other-window-or-split)

; Dired用にウィンドウ切り替え設定
(add-hook 'dired-mode-hook
      (lambda ()
        (define-key dired-mode-map (kbd "C-o") 'other-window)))

(setq windmove-wrap-around t)
(windmove-default-keybindings)


(use-package ace-jump-mode
  :defer t
  :bind (( "C-/" . ace-jump-mode ))
  :init
  (autoload 'ace-jump-mode "ace-jump-mode" nil t)
  :config
 
  )

;;;dired 

  
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs"))
(setq migemo-user-dictionary nil)
(setq migemo-coding-system 'utf-8)
(setq migemo-regex-dictionary nil)
(load-library "migemo")
(migemo-init)
(require 'popwin)
(require 'dired)
(require 'dired-x)
(require 'dired-toggle)
(require 'dired-details)
(require 'direx)

(setq display-buffer-function 'popwin:display-buffer)

;;diaplay-buffer-functionを変更したくない人向け
;;(setq special-display-function 'popwin:special-display-popup-window)

(setq popwin:special-display-config '(("*scratch*")
                                      ("*Dired\  Toggle*")))
;(display-buffer "*scratch*")

(push '(dired-mode :position left :width 40) popwin:special-display-config)

(setq direx:lead-icon   "  "
      direx:open-icon   "- "
      direx:closed-icon "+ ")
(push '(direx:direx-mode :position left :width 40 :dedicated t)
      popwin:special-display-config)

(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)
(global-set-key (kbd "C-x C-d") 'dired-toggle)
(dired-details-install)

(setq dired-details-hidden-string "")
(setq dired-details-hide-link-targets nil)

(defadvice find-dired-sentinel (after dired-details (proc state) activate)
  "find-diredでもdired-detailsを使えるようにする"
  (ignore-errors
    (with-current-buffer (process-buffer proc)
      (dired-details-activate))))

(require 'swoop)
(global-set-key (kbd "C-;")   'swoop)
(global-set-key (kbd "C-M-;") 'swoop-multi)
(global-set-key (kbd "M-;")   'swoop-pcre-regexp)
(global-set-key (kbd "C-S-;") 'swoop-back-to-last-position)
(global-set-key (kbd "M-6")   'swoop-migemo) ;; Option for Japanese match

;; 検索の移行
;; isearch     > press [C-;] > swoop
;; evil-search > press [C-;] > swoop
;; swoop       > press [C-;] > swoop-multi
(define-key isearch-mode-map (kbd "C-;") 'swoop-from-isearch)
;(define-key evil-motion-state-map (kbd "C-;") 'swoop-from-evil-search)
(define-key swoop-map (kbd "C-;") 'swoop-multi-from-swoop)

(setq sqoop-font-size-change: nil)


(use-package helm
  :config
  (helm-mode)
  )

(use-package helm-swoop
  :config
  )
(use-package  helm-migemo
  :config
  )

(use-package smex
  :bind (("M-x" . smex))
  :config
  )

(use-package visual-regexp
  :bind (("M-%" . vr/query-replace))
  :config
  )
