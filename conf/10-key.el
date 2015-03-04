(require 'misc)
;;1行コピー
(global-set-key (kbd "C-y") 'duplicate-line)

;;バッファ全体をインデント
(global-set-key (kbd "s-;") 'indent-whole-buffer) 

;;C-hでバックスペース
(global-set-key (kbd "C-h") 'backward-delete-char)

;;単語移動
(global-set-key (kbd "C-[left]") 'forward-word)
(global-set-key (kbd "C-[right]") 'backward-word)

;;C-z無効化
(global-unset-key "\C-z")

(global-set-key (kbd "C-x i") 'imenu)
