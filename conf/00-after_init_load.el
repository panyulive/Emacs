(add-hook 'after-init-hook
		  (lambda()
			(global-auto-complete-mode)
				 (message "init time: %.3f sec"
						  (float-time (time-subtract after-init-time before-init-time))))
		  )
