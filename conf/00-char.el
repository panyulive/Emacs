(setq default-input-method "MacOSX")

(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)

(setq windmove-wrap-around t)
(windmove-default-keybindings)

;; ファイル名補完で大文字小文字を区別しない
(setq read-buffer-completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

(fset 'yes-or-no-p 'y-or-n-p)

