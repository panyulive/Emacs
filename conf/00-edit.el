(require 'mac-win)

;; cua-modeの設定
(cua-mode t)  ; cua-modeをオン
(setq cua-enable-cua-keys nil)  ; CUAキーバインドを無効化

;; indent
(add-hook 'sh-mode-hook '(lambda () (interactive)
        (setq sh-basic-offset 2 sh-indentation 2)))

;; .zshrc* を shell-script-mode に
(add-to-list 'auto-mode-alist
        '("\\.zshrc" . shell-script-mode))

