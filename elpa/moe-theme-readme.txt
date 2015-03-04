You can take a look at screenshots and acquire more information on:
    https://github.com/kuanyui/moe-theme.el


Requirements

  - Emacs 24 (or above)
  - 256 colors terminal (or higher)

Usage

  Add you to your .emacs:

	(load-theme 'moe-dark t)
               or
	(load-theme 'moe-light t)


Auto Switching

  I prefer a terminal with a black-on-white color scheme. I found that in the daytime, sunlight is strong and black-on-white is more readable; However, white-on-black would be less harsh to the eyes at night.

  So if you like, you can add the following line to your ~/.emacs to automatically switch between moe-dark and moe-light according to the system time:

	(require 'moe-theme-switcher)

  By adding the line above, your Emacs will have a light theme in the day and a dark one at night. =w=+


Live in Antarctica?

  Daytime is longer in summer but shorter in winter; or you live in a high latitude region which midnight-sun or polar-night may occur such as Finland or Antarctica?

  There's a variable `moe-theme-switch-by-sunrise-and-sunset` would solve your problem (default value is `t`)

  If this value is `nil`, `moe-theme-switcher` will switch theme at fixed time (06:00 and 18:00).

  If this value is `t` and both `calendar-latitude` and `calendar-longitude` are set properly, the switching will be triggered at the sunrise and sunset time of the local calendar.

  Take "Keelung, Taiwan" (25N,121E) for example, you can set like this:

	(setq calendar-latitude +25)
	(setq calendar-longitude +121)
