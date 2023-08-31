;; Last updated: Time-stamp: <2023-08-23 21:41:27 lcn>

;; -*- lexical-binding: t; -*-

(setq inhibit-startup-screen t)
(add-hook 'before-save-hook 'time-stamp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Startup emacs server to enable running 'emacsclient'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(server-start)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Install straight.el

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq default-directory "/home/lcn/_NAS/_DOCUMENTS/")
(setq org-directory     "/home/lcn/_NAS/_DOCUMENTS/_ORG/")

;; The following settings have been suggested by Protesilaos
(setq vertico-mode 1)
(vertico-mode 1)
(setq marginalia-mode 1)
(file-name-shadow-mode 1)
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)
(setq delete-by-mmoving-to-trash t)
(setq dired-dwim-terget t)
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
(setq dired-guess-shell-alist-user
      '(("\\.\\(png\\|jpe?g\\|tiff\\)" "feh" "xdg-open")
        ("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)" "mpv" "xdg-open")
		(".*" "xdg-open")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Who am I
(setq user-full-name "Leo Noordhuizen"
      user-mail-address "Leo.Noordhuizen@gmail.com")

;; Highlight matching pairs of parentheses.
(setq show-paren-delay 0)
(show-paren-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Browse URLS in text mode
(global-goto-address-mode +1)            ;; Buttonize URLs and Email-adresses

;; Recent files
(recentf-mode 1)                         ;; Display the "Open Recent" submenu of the "File" menu
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; Load special initfile if it exists
(when (file-exists-p "~/.emacs.d/personal.el")
    (load "~/.emacs.d/personal.el"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; accept abbreviated 'yes' and 'no'
(fset 'yes-or-no-p 'y-or-n-p)

;; Various settings
;; oa Backups
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))      ;; The location of backupfiles
(setq delete-old-versions t)           ;; Old backup versions will be deleted
(setq version-control t)               ;; If more versions of backups, number them
(setq vc-make-backup-files nil)        ;; Files under version control are not backupped
(setq select-enable-clipboard t)       ;; Play nice(er) with the X11 clipboard
(setq transient-mark-mode 1)           ;; Enable transient mark mode
(setq initial-scratch-message nil)     ;; No text needed in the *scratch* buffer
(set-face-attribute 'default nil
		    :height 128)       ;; Vergroot font
(setq-default fill-column 90)

(savehist-mode +1)                       ;; Save Mini-buffer History

;; Additionally save the following variables:
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

(display-time-mode 1)                  ;; Display time in modeline
(show-paren-mode t)                    ;; Highlight corresponding parens

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dired
(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

(add-hook 'dired-mode-hook 'dired-hide-details-mode)
(setq delete-by-moving-to-trash t)
(setq dired-dwim-target t)

;; packages
;;--------------------------------------
(require 'package)

(setq package-enable-at-startup nil)
(setq package-archives '(("org"   . "http://orgmode.org/elpa")
                         ("gnu"   . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

;; PACKAGES
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; use-package
(unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

;; Ensure that packages are installed without having to add :ensure t everywhere 
;;--------------------------------------
(require 'use-package)

;; ensure that packages are installed w/out having to add :ensure t everywhere 
(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; Keep packages up-to-date
(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; org-chef
;;--------------------------------------
(use-package org-chef
  :ensure t)

;; org-pandoc-import
;;--------------------------------------
(use-package org-pandoc-import
  :straight (:host github
		   :repo "tecosaur/org-pandoc-import"
		   :files ("*.el" "filters" "preprocessors")))

;; COMPANY 
;;--------------------------------------
(use-package company
  :init (setq company-dabbrev-downcase 0 company-idle-delay 0)
  :diminish
  :config (progn (company-mode +1)
		 (global-company-mode +1)))

;; ELISP
;;--------------------------------------
(use-package elisp-format)

;; Ivy mode (part of counsel)
;;--------------------------------------
(ivy-mode 1)
(setq ivy-count-format "(%d/%d) ")

;; ORG MODE
;;--------------------------------------
(use-package org
  :mode (("\\.org$" . org-mode))
  :config 
  (setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d!)" "CANCELLED(c@)") ;; basic boolean todo lists
        (sequence "NEXT" "DOING" "|" "DONE")))
  (setq org-fontify-done-headline t)
  (setq org-todo-keyword-faces
	'(("TODO" . org-warning) ("DOING" . "yellow") ("NEXT" . (:foreground "blue" :weight bold))))
  (setq org-log-done 'time)
  )

(setq org-startup-folded t)    ;; Open an Org file 'folded'

(use-package org-bullets
  :after org
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq org-default-notes-file (concat org-directory "/notes.org"))

(add-hook 'org-mode-hook (lambda () (auto-fill-mode)))

;; Org-mode custom font
(add-hook 'org-mode-hook (lambda ()
                           (setq buffer-face-mode-face '(:family "APL385 Unicode" :height 120))
                           (buffer-face-mode)))

(require 'org-protocol)

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(setq org-refile-use-outline-path t)
(setq org-refile-targets '(("tickler.org" :maxlevel . 1)
                                 ("organizer.org" :maxlevel . 1)
                                 ("someday.org" :maxlevel . 2)))

(set-face-attribute 'org-table nil  :inherit 'fixed-pitch)


;; Capture templates
;;-----------
(setq org-capture-templates
      '(
	("c" "Cookbook" entry
	 (file "~/_NAS/_DOCUMENTS/_ORG/cookbook.org")
	 "%(org-chef-get-recipe-from-url)"
	 :empty-lines 1)
	("m" "Manual Cookbook" entry
	 (file "~/_NAS/_DOCUMENTS/_ORG/cookbook.org")
	 "* %^{Recipe title: }\n  :PROPERTIES:\n  :source-url:\n  :servings:\n 
                                  :prep-time:\n  :cook-time:\n 
                                  :ready-in:\n  :END:\n** Ingredients\n   %?\n** Directions\n\n")
	("t" "Todo" entry
	 (file+headline "~/_NAS/_DOCUMENTS/_ORG/todo.org" "Tasks")
	 "* TODO %?\n  %i\n")
	("j" "Journal" entry
	 (file+datetree "~/_NAS/_DOCUMENTS/_ORG/journal.org" "Journal")
	 "* %?;;------------------------------\n%x\n\n;;------------------------------\n\nGenoteerd op %T\n")
	("x" "Bookmark" entry
	 (file+headline "~/doc/org/org-files/INBOX.org" "Bookmarks")
	 "* %c %?\n:PROPERTIES: \n:Category: \n:CREATED: %U \n:END:\n")
	("p" "Protocol" entry
	 (file+headline "~/captest.org" "Protocol")
	 "* [[%:link][%:description]]\nCaptured On: %U\n#+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n\n%?"
	 :empty-lines-after 1
	 :immediate-finish t)
	("L" "Temp Links from the interwebs" entry
	 (file+headline "~/captest.org" "Interwebs")
	 "* [[%:link][%:description]]\nCaptured On: %U"
	 :empty-lines-after 1
	 :immediate-finish t)
	("r" "record" plain
	 (file "~/_NAS/_DOCUMENTS/_ORG/records.org")
	 "* %^{Title} :%^{Tags}:\n%U%i\n%?\n")
	)
      )

(setq org-default-notes-file (concat org-directory "notes.org"))

;; refile targets (testing)
;;-------------------------
(setq org-refile-targets
      '("/home/lcn/inbox.org"))

;; Enable easy insertion of codeblocks (<[char]<tab>)
;;------------------------------------
(require 'org-tempo)

;; Include Emacs diary
;;------------------------------------
(setq org-agenda-include-diary t)

;; End org-mode
;;**********************************************************************************************

(use-package org-download
  :after org
  :defer nil
  :custom
  (org-startup-indented t)
  (org-download-method 'directory)
  (org-download-image-dir "images")
  (org-download-heading-lvl nil)
  (org-download-timestamp "%Y%m%d-%H%M%S_")
  (org-image-actual-width 300)
  :bind
  ("C-M-y" .
   (lambda (&optional noask)
     (interactive "P")
     (let ((file
            (if (not noask)
                (read-string (format "Filename [%s]: " org-download-screenshot-basename)
                             nil nil org-download-screenshot-basename)
              nil)))
       (org-download-clipboard file))))
  :config
  (require 'org-download))

;;***********************************************************************************************
;; Habits
;;------------------------------------
(require 'org-habit)

;;***********************************************************************************************
;; Org-roam
;;------------------------------------
(use-package org-roam
  :after org
  :custom
  (org-roam-directory "/home/lcn/_NAS/_DOCUMENTS/_ROAM")
  (org-roam-completion-everywhere t)
  :bind (("C-c n r" . org-roam-node-random)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c d c" . org-roam-dailies-capture-today)
	 :map org-mode-map
	 ("C-c n i" . org-roam-node-insert)
	 ("C-c n o" . org-id-get-create)
	 ("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n a" . org-roam-alias-add)
	 ("C-c n t" . org-roam-today)
	 ("C-c n g" . org-roam-graph)
	 ("C-M-i"   . completion-at-point)
	 ;; Dailies
	 ("C-c d t" . org-roam-dailies-goto-today)
	 ("C-c d p" . org-roam-dailies-goto-previous-note)
	 ("C-c d n" . org-roam-dailies-goto-next-note)
	 ("C-c d C" . org-roam-dailies-capture-date)
	 ("C-c d d" . org-roam-dailies-goto-date))

  :config
  ;; If you are using a vertical completion framework, you might want a more informative completion interface

  (setq org-roam-node-display-template (concat "${title:*} "
					       (propertize "${tags:10}" 'face 'org-tag)))

  (setq org-roam-dailies-capture-templates
	'(("d" "default" entry "* %<%I:%M %p>: %?"
	   :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))))

  (setq org-roam-mode-sections
	(list #'org-roam-backlinks-section
	      #'org-roam-reflinks-section
	      #'org-roam-unlinked-references-section
	      ))

  (add-to-list 'display-buffer-alist
	       '("\\*org-roam\\*"
		 (display-buffer-in-direction)
		 (direction . right)
		 (window-width . 0.33)
		 (window-height  . fit-window-to-buffer)))

  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package org-roam-ui
  :after org-roam
;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;;***********************************************************************************************
(use-package deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-extensions '("org" "txt" "text" "md" "markdown" "org.gpg"))
  (deft-default-extension "org")
  (deft-directory org-roam-directory))
 
;; Which key - shows which key can be pressed after an initial keypress
;;------------------------------------
(use-package which-key
    :init (which-key-mode)
    :diminish which-key-mode
    :config
      (setq which-key-idle-delay 0.3))

;;***********************************************************************************************
;; elfeed RSS reader
;;------------------------------------
(global-set-key (kbd "C-x w") 'elfeed)

;; Load Elfeed-org
;; default "~/.emacs.d/elfeed.org" is used as configurationfile
;; 
(require 'elfeed-org)
(elfeed-org)
(setq rmh-elfeed-org-files (list "~/.emacs.d/elfeed.org"))

;;***********************************************************************************************
;; Open init file for editing
;;------------------------------------
(defun config-visit ()
  "Load ~/.emacs.d/init.el for editing."
  (interactive)
  (find-file (expand-file-name (locate-user-emacs-file "init.el"))))

(global-set-key (kbd "C-c e v") 'config-visit)

;;***********************************************************************************************
;; Epub reader
;;-----------------------------------
(use-package nov
    :config
    (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
    )

;; Toevoegingen om de leesbaarheid te verbeteren
;; De speciale settings zijn overgenomen van https://chainsawriot.com/postmannheim/2022/12/22/aoe22.html

(defun my-nov-font-setup ()
  (face-remap-add-relative 'variable-pitch :family "Liberation Serif"
                                           :height 1.0))
(add-hook 'nov-mode-hook 'my-nov-font-setup)
(setq nov-text-width 80) 
(setq nov-text-width t)
(setq visual-fill-column-center-text t)
(add-hook 'nov-mode-hook 'visual-line-mode)
(add-hook 'nov-mode-hook 'visual-fill-column-mode)

(defun nov-display ()
  (face-remap-add-relative 'variable-pitch :family "Liberation Serif"
						   :height 1.5)
  (toggle-scroll-bar -1)
  (setq mode-line-format nil
		nov-header-line-format ""
		cursor-type nil))
(setq nov-text-width 120)

;;***********************************************************************************************
;; Eval in repl - evaluate elisp expressions
(use-package eval-in-repl
  :bind (
		 :map emacs-lisp-mode-map
			  ("C-q" . 'eir-eval-in-ielm)
			  :map lisp-interaction-mode-map
			  ("C-q" . 'eir-eval-in-ielm)
			  :map Info-mode-map
			  ("C-q" . 'eir-eval-in-ielm))
  :config
  (require 'eval-in-repl-ielm)
  :init
  (setq eir-ielm-eval-in-current-buffer t)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; For Common Lisp development

;; Install packages.
(dolist (package '(sly paredit rainbow-delimiters))
  (unless (package-installed-p package)
    (package-install package)))

;; Configure SBCL as the Lisp program for Sly.
(setq inferior-lisp-program "/usr/bin/sbcl")

(eval-after-load 'sly
  '(define-key sly-prefix-map (kbd "M-h") 'sly-documentation-lookup))

;; Enable Paredit.
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'sly-repl-mode-hook 'enable-paredit-mode)
(defun override-sly-del-key ()
  (define-key sly-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil))
(add-hook 'sly-repl-mode-hook 'override-sly-del-key)

;; Enable Rainbow Delimiters.
(require 'rainbow-delimiters)

(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'ielm-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lisp-interaction-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'sly-repl-mode-hook 'rainbow-delimiters-mode)

;; Customize Rainbow Delimiters.
(set-face-foreground 'rainbow-delimiters-depth-1-face "#c66")  ; red
(set-face-foreground 'rainbow-delimiters-depth-2-face "#6c6")  ; green
(set-face-foreground 'rainbow-delimiters-depth-3-face "#69f")  ; blue
(set-face-foreground 'rainbow-delimiters-depth-4-face "#cc6")  ; yellow
(set-face-foreground 'rainbow-delimiters-depth-5-face "#6cc")  ; cyan
(set-face-foreground 'rainbow-delimiters-depth-6-face "#c6c")  ; magenta
(set-face-foreground 'rainbow-delimiters-depth-7-face "#ccc")  ; light gray
(set-face-foreground 'rainbow-delimiters-depth-8-face "#999")  ; medium gray
(set-face-foreground 'rainbow-delimiters-depth-9-face "#666")  ; dark gray

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;Eshell test;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'eshell)
(require 'em-smart)
(setq eshell-where-to-jump 'begin)
(setq eshell-review-quick-commands nil)
(setq eshell-smart-space-goes-to-end t)
(add-to-list 'eshell-modules-list 'eshell-smart)
(setq eshell-banner-message "")
(setq eshell-history-size 500)
(setq eshell-save-history-on-exit t)
(setq eshell-hist-ignoredups t)
(setq eshell-last-dir-ring-size 500)
(setq eshell-prompt-regexp "^[^$\n]* [#$] ")
(defun eshell-clear-buffer ()
  "clear the current eshell buffer"
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)
    (eshell-send-input)))
(add-hook 'eshell-mode-hook
          (lambda ()
            (local-set-key (kbd "C-l") 'eshell-clear-buffer)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(modus-vivendi))
 '(display-time-mode t)
 '(org-agenda-files
   '("~/_NAS/_DOCUMENTS/_ROAM/20230104150029-golf.org" "/home/lcn/_NAS/_DOCUMENTS/_ORG/todo sometime.org" "/home/lcn/_NAS/_DOCUMENTS/_ORG/todo.org" "/home/lcn/_NAS/_DOCUMENTS/_ORG/agenda.org"))
 '(org-modules
   '(ol-bbdb ol-bibtex ol-docview ol-doi ol-eww ol-gnus org-habit ol-info ol-irc ol-mhe ol-rmail ol-w3m))
 '(package-selected-packages
   '(eval-in-repl nov pdf-tools org-roam-ui org-roam org-pomodoro elfeed use-package-ensure-system-package counsel)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight normal :height 120 :width normal))))
 '(org-done ((t (:foreground "#5DA7AA" :weight normal :strike-through t))))
 '(org-headline-done ((((class color) (min-colors 16) (background light)) (:foreground "#5E81AC" :strike-through t)))))
