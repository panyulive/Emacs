(require 'cl)
(require 'yasnippet)
;;問い合わせを簡略化
(fset 'yes-or-no-p 'y-or-n-p)

(setq yas-snippet-dirs
	  '("~/.emacs.d/snippets"
		"~/.emacs.d/elpa/yasnippet-20130505.2115/snippets"))

(yas-global-mode)

(custom-set-variables '(yas-trigger-key "TAB"))

;;新規snippetを作成するバッファを用意する
(define-key yas-minor-mode-map (kbd "C-x C-y C-n") 'yas-new-snippet)
;;既存snippetを閲覧編集する
(define-key yas-minor-mode-map (kbd "C-x C-y C-e") 'yas-visit-snippet-file)
