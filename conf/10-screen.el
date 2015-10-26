


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

;;行番号の表示


(setq custom-theme-directory "~/.emacs.d/themes/")
(load-theme 'atom-one-dark t)

;;行列表示
(column-number-mode)
(line-number-mode)

;;行番号表示
(global-linum-mode t)
(setq linum-format " %d ")

(text-scale-set 1)

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
