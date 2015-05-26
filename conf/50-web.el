(use-package web-mode

  :mode (
		 "\\.phtml\\'"    
		 "\\.tpl\\.php\\'"
		 "\\.[agj]sp\\'"  
		 "\\.as[cp]x\\'"  
		 "\\.erb\\'"      
		 "\\.mustache\\'" 
		 "\\.djhtml\\'"   
		 )
  
  :init
 ;; (add-to-list 'auto-mode-alist '("\\.phtml\\'"     . web-mode))
 ;; (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
 ;; (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'"   . web-mode))
 ;; (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'"   . web-mode))
 ;; (add-to-list 'auto-mode-alist '("\\.erb\\'"       . web-mode))
 ;; (add-to-list 'auto-mode-alist '("\\.mustache\\'"  . web-mode))
 ;; (add-to-list 'auto-mode-alist '("\\.djhtml\\'"    . web-mode))

  (defun web-mode-hook ()
	  (setq web-mode-markup-indent-offset   2)
	  (setq indent-tabs-mode t)
	  )
  :config
  (add-hook 'web-mode-hook 'web-mode-hook)
  )
