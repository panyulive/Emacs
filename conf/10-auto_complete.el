;;これで自動で補完される
;;C-sのサーチ機能と上手く使って使いこなす
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories 
    "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

 (global-auto-complete-mode)
(define-key ac-complete-mode-map "\C-j" 'ac-next)
(define-key ac-complete-mode-map "\C-k" 'ac-previous)
