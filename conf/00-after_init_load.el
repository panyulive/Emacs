(add-hook 'after-init-hook
		  (lambda()
				 (message "init time: %.3f sec"
             (float-time (time-subtract after-init-time before-init-time)))))
