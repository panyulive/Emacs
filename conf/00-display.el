;;line-number
(column-number-mode)
(line-number-mode)
(global-linum-mode t)

(setq ring-bell-function 'ignore)
;; リージョン内の行数と文字数をモードラインに表示する（範囲指定時のみ）
(defun count-lines-and-chars ()
  (if mark-active
      (format "[%d,%d] "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
      ;; これだとエコーエリアがチラつく
      ;;(count-lines-region (region-beginning) (region-end))
    ""))
;;;ここから通らない
(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))

;;タイトルにファイルフルパスの表示
(setq frame-title-format "%f")

;;１行ずつシフト
;(setq scroll-conservatively 35
;      scroll-margin 0
;      scroll-step 1)
;(setq comint-scroll-show-maximum-output t);;shell-mode

;;物理行の移動
(setq line-mode-visual nil)


;;括弧選択の下線表示設定
;;hight-line-config
(defface hlline-face
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
;; parenのスタイル: expressionは括弧内も強調表示
(setq show-paren-style 'expression)
;; フェイスを変更する
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")

;;color-change
(if window-system (progn

  ;; 文字の色を設定します。
  (add-to-list 'default-frame-alist '(foreground-color . "white"))
  ;; 背景色を設定します。
  (add-to-list 'default-frame-alist '(background-color . "black"))
  ;; カーソルの色を設定します。
  (add-to-list 'default-frame-alist '(cursor-color . "lightBlue2"))
  ;; マウスポインタの色を設定します。
  (add-to-list 'default-frame-alist '(mouse-color . "Blue2"))
  ;; モードラインの文字の色を設定します。
  (set-face-foreground 'modeline "white")
  ;; モードラインの背景色を設定します。
  (set-face-background 'modeline "darkgreen")
  ;; 選択中のリージョンの色を設定します。
  (set-face-background 'region "LightSteelBlue1")
  ;; モードライン（アクティブでないバッファ）の文字色を設定します。
  (set-face-foreground 'mode-line-inactive "gray30")
  ;; モードライン（アクティブでないバッファ）の背景色を設定します。
  (set-face-background 'mode-line-inactive "gray85")
  ;;透過設定
  (set-frame-parameter nil 'alpha 100)



))

(set-frame-height (next-frame) 35)
(set-frame-width (next-frame) 120)
