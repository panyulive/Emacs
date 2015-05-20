;; js2-mode
;; https://github.com/mooz/js2-mode/tree/
(use-package js2-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
  (custom-set-variables
   '(js2-auto-indent-p t)
   '(js2-indent-tabs-mode nil) ; indent is space
   '(js2-basic-offset 2)
   '(js2-enter-indents-newline t)
   '(js2-indent-on-enter-key t)
   '(js2-mirror-mode t))
  )

(setq js2-mode-hook
	  '(lambda() (progn
				   (set-variable 'indent-tabs-mode nil))))

