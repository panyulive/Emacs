
;; C-z c    |新規スクリーンを作成して移動
;; C-z k    |現在のスクリーンを閉じる
;; C-z p    |前のスクリーンへ
;; C-z n    |次のスクリーンへ
;; C-z a    |前と次のスクリーンをトグル
;; C-z [0-9]|番号のスクリーンへ
;; C-z ?    |ヘルプ

(global-unset-key "\C-z")

(require 'elscreen)
(setq elscreen-prefix-key (kbd "C-z"))
(elscreen-start)

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

