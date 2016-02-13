(require 'use-package)
(require 'bind-key)
(require 'elscreen)

(global-unset-key (kbd "C-z"))
(setq elscreen-prefix-key (kbd "C-z"))
(elscreen-start)

(use-package multi-eshell
  :bind ("C-c c t" . elscreen-esh)
  :init 
  (setq multi-eshell-shell-function '(eshell))
  (setq multi-eshell-name "*eshell*")

  (defun elscreen-esh ()
    (interactive)
    (elscreen-create)
    (multi-eshell 1))
  
  :config
)


(add-hook 'after-init-hook
		  (lambda()
			(global-auto-complete-mode)
				 (message "init time: %.3f sec"
						  (float-time (time-subtract after-init-time before-init-time))))
		  )
(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)

(setq windmove-wrap-around t)
(windmove-default-keybindings)

;; ファイル名補完で大文字小文字を区別しない
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

(fset 'yes-or-no-p 'y-or-n-p)

(setq ring-bell-function 'ignore)

;(global-set-key (kbd "C-y") 'duplicate-line)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-x C-i") 'helm-imenu)

(global-set-key (kbd "M-r") 'revert-buffer-no-confirm)


;(require 'mac-win)

;; cua-modeの設定
(cua-mode t)  ; cua-modeをオン
(setq cua-enable-cua-keys nil)  ; CUAキーバインドを無効化

;; indent
(add-hook 'sh-mode-hook '(lambda () (interactive)
        (setq sh-basic-offset 2 sh-indentation 2)))

;; .zshrc* を shell-script-mode に




(defun indent-whole-buffer()
  (inrerctive)
  (indent-region (point-min) (point-max)))

(defun duplicate-line (&optional numlines)
  "One line is duplicated wherever there is a cursor."
  (interactive "p")
  (let* ((col (current-column))
         (bol (progn (beginning-of-line) (point)))
         (eol (progn (end-of-line) (point)))
         (line (buffer-substring bol eol)))
    (while (> numlines 0)
      (insert "\n" line)
      (setq numlines (- numlines 1)))
    (move-to-column col)))

(defun all-sjis ()
	(interactive)
	(set-default-coding-systems `sjis)
	(set-keyboard-coding-system `sjis)
	(setq default-buffer-file-coding-system `sjis))

(defun all-def ()
  (interactive)
	(set-default-coding-systems `utf-8)
	(set-keyboard-coding-system `utf-8)
	(setq default-buffer-file-coding-system `utf-8))
;(setq default-input-method "MacOSX")
; 
;(mac-set-input-method-parameter "com.google.inputmethod.Japanese.base" `title "あ")
; 
;;; カーソルの色
;(mac-set-input-method-parameter "com.google.inputmethod.Japanese.base" `cursor-color "red")
;(mac-set-input-method-parameter "com.google.inputmethod.Japanese.Roman" `cursor-color "blue")
; 
;;; backslash を優先
;(mac-translate-from-yen-to-backslash)
; 
; 
;;; minibuffer 内は英数モードにする
;(add-hook 'minibuffer-setup-hook 'mac-change-language-to-us)
; 
;;; [migemo]isearch のとき IME を英数モードにする
;(add-hook 'isearch-mode-hook 'mac-change-language-to-us)

;;;終了時バイトコンパイル
(add-hook 'kill-emacs-query-functions
          (lambda ()
            (if (file-newer-than-file-p (concat user-emacs-directory "init.el") (concat user-emacs-directory "init.elc"))
                (byte-compile-file (concat user-emacs-directory "init.el")))
            ;(if (file-newer-than-file-p (concat user-emacs-directory "filecachedir.el") (concat user-emacs-directory "filecachedir.elc"))
            ;    (byte-compile-file (concat user-emacs-directory "filecachedir.el")))
            (byte-recompile-directory (concat user-emacs-directory "conf") 0)
            )
)
(text-scale-set 1)
;;行番号表示
(global-linum-mode t)
(setq linum-format " %d ")


(setq custom-theme-directory "~/.emacs.d/themes/")
(load-theme 'atom-one-dark t)

;;行列表示
(column-number-mode)
(line-number-mode)

;;行番号表示
(global-linum-mode t)
(setq linum-format " %d ")

(text-scale-set 1)

(powerline-default-theme)

;;文字数カウント
(defun count-lines-and-chars ()
  (if mark-active
      (format "[%d,%d] "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
    ""))
(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))

;;タイトルをパスに変更
(setq frame-title-format "%f")

;;下線表示
(defface hlline-facea
  '((((class color)
      (background dark))
     (:background "darkgreen"))
    (((class color)
      (background light))
     (:background "#CC0066"))
    (t
     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
(global-hl-line-mode)

(setq show-paren-delay 0) ; 表示までの秒数。初期値は0.125
(show-paren-mode t) ; 有効化
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)



(use-package ctags
  :bind
  ("<f5>" . ctags-create-or-update-tags-table)
  ("M-."  . ctags-search)
  :init
  (require 'anything-exuberant-ctags)
  (setq tags-revert-without-query t)
  (setq ctags-command "ctags -e -R --fields=\"+afikKlmnsSzt\" ")

  )

(global-font-lock-mode 1)
  (setq default-frame-alist
      (append
       '(;;(foreground-color . "gray")  ;
         (background-color . "black") ;
        ;; (cursor-color     . "blue")  ;
        )
       default-frame-alist))
  


;;コピペの設定
;(setq x-select-enable-clipboard nil)
;(setq x-select-enable-primary t)
;(setq mouse-drag-copy-region t)



;(setq default-directory "~/") 
;(setq command-line-default-directory "~/")
; 
; 
;(defun mac-selected-keyboard-input-source-change-hook-func ()
;  ;; 入力モードが英語の時はカーソルの色をfirebrickに、日本語の時はblackにする
;  (set-cursor-color (if (string-match "\\.US$" (mac-input-source))
;                        "firebrick" "white")))
; 
;(add-hook 'mac-selected-keyboard-input-source-change-hook
;          'mac-selected-keyboard-input-source-change-hook-func)
; 
;(require 'mac-win)
;(mac-auto-ascii-mode t)
;(setq default-imput-method "MacOS")
