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

  :config
  (defun web-mode-hook ()
	  (setq web-mode-markup-indent-offset   2)
	  (setq indent-tabs-mode t)
	  )

  (add-hook 'web-mode-hook 'web-mode-hook)
  )
