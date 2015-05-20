;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;default
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(require 'cl)
(setq exec-path (cons "/usr/local/bin"exec-path))

(tool-bar-mode 0)
(scroll-bar-mode 0)

(defvar user-emacs-directory "~/.emacs.d/")

(setq make-backup-files t)
(setq backup-directory-alist
  (cons (cons "\\.*$" (expand-file-name "~/.emacs.d/backup"))
	backup-directory-alist))

(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "elpa")

(setq default-input-method "MacOSX")

(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)

(setq windmove-wrap-around t)
(windmove-default-keybindings)

;; ファイル名補完で大文字小文字を区別しない
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

(fset 'yes-or-no-p 'y-or-n-p)

(setq ring-bell-function 'ignore)

(global-set-key (kbd "C-y") 'duplicate-line)
(global-set-key (kbd "C-h") 'indent-whole-buffer)
(global-set-key (kbd "C-x C-i") 'helm-imenu)



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
(global-set-key (kbd "C-t") 'other-window-or-split)

; Dired用にウィンドウ切り替え設定
(add-hook 'dired-mode-hook
      (lambda ()
        (define-key dired-mode-map (kbd "C-t") 'other-window)))

(setq windmove-wrap-around t)
(windmove-default-keybindings)

;;行番号の表示


(setq custom-theme-directory "~/.emacs.d/themes/")
(load-theme 'sunburst t)

;;行列表示
(column-number-mode)
(line-number-mode)

;;行番号表示
(global-linum-mode t)
(setq linum-format " %d")

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

(setq-default tab-width 4)
(setq-default indent-tabs-mode t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;elscreen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'elscreen)
(elscreen-start)

;;タブの状態永続化
;;(require 'elscreen-persist)
;;(elscreen-persist-mode t)

(setq elscreen-prefix-key (kbd "C-z"))
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
(global-set-key (kbd "C-o") 'elscreen-next)


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

