;; C-z c    |新規スクリーンを作成して移動
;; C-z k    |現在のスクリーンを閉じる
;; C-z p    |前のスクリーンへ
;; C-z n    |次のスクリーンへ
;; C-z a    |前と次のスクリーンをトグル
;; C-z [0-9]|番号のスクリーンへ
;; C-z ?    |ヘルプ

(require 'elscreen)
(elscreen-start)

(require 'elscreen-persist)

(elscreen-persist-mode t)

(setq elscreen-prefix-key (kbd "C-z"))
;;タブの設定に[X]を表示しない
(setq elscreen-tab-display-kill-screen nil)
;;header-lineに[<->]を表示しない
(setq elscreen-tab-display-control nil)

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
(define-key global-map (kbd "C-o") 'elscreen-next)
