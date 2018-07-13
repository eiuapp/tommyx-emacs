;; requires
(require 'evil)
(require 'org-super-agenda)
(require 'org-pomodoro)

;; startup settings
(add-hook 'org-mode-hook (lambda () (interactive)
	(setq-local indent-tabs-mode nil) ; use space instead of tabs
))

;; use clean (indented) view
(setq org-startup-indented t)

;; check if org-notes-dir exists.
;; (when (boundp 'org-agenda-dir)

;; todo
(setq org-todo-keywords '((sequence "TODO" "DONE")))

;; refiling
(setq org-refile-targets '((nil . (:level . 1)) (nil . (:level . 2))))

;; priorities
(setq org-lowest-priority ?3)
(setq org-highest-priority ?1)
(setq org-default-priority ?3)
(setq org-priority-faces '((?1 . (:inherit error :bold t)) (?2 . (:inherit warning :bold t))  (?3 . (:inherit success :bold t))))

;; ivy integration
(setq counsel-org-headline-display-style 'path)
(setq counsel-org-headline-path-separator "/")

;; agenda files
(add-to-list 'org-agenda-files org-directory)

;; super agenda groups
(setq org-super-agenda-groups '(
	(:name "Time Grid"
		:time-grid t
	)
	(:name "Overdue"
		:deadline past
	)
	(:name "Due"
		:deadline today
	)
	(:name "Important + Urgent"
		:and (:priority "1")
	)
	(:name "Primary"
		:and (:priority "2")
	)
	(:name "Recurring"
		:and (:tag ("recurring"))
	)
	(:name "Secondary"
		:and (:priority "3")
	)
	(:name "Other Items"
		:anything
	)
))

;; clocking
; ask for clock-out on leave
(defun my/org-clock-query-out ()
	"Ask the user before clocking out.
	This is a useful function for adding to `kill-emacs-query-functions'."
	(if (and
		(featurep 'org-clock)
		(funcall 'org-clocking-p)
		(y-or-n-p "You are currently clocking time, clock out? "))
		(org-clock-out) t)) ;; only fails on keyboard quit or error
(add-hook 'kill-emacs-query-functions 'my/org-clock-query-out) ; timeclock.el puts this on the wrong hook!

;; agenda configs
(setq org-agenda-window-setup 'only-window)
(setq org-agenda-start-with-clockreport-mode t)
(setq org-clock-report-include-clocking-task t)
(setq org-agenda-start-with-log-mode t)
(setq org-agenda-log-mode-items '(closed clock state))
(setq org-agenda-restore-windows-after-quit t)
(setq org-agenda-use-tag-inheritance t) ; tag inheritance in agenda (turn off if slow)
(setq org-agenda-sticky nil) ; make sure to refresh agenda when re-launch
(setq org-agenda-span 'day)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-scheduled-if-deadline-is-shown t)
(setq org-agenda-move-date-from-past-immediately-to-today t)
(org-super-agenda-mode)
(evil-set-initial-state 'org-agenda-mode 'motion)
(add-hook 'org-agenda-mode-hook (lambda () (hl-line-mode 1)))
(setq org-agenda-time-grid '((daily today)
 (800 1000 1200 1400 1600 1800 2000)
 "......" "----------------"))

;; entry text filter
; remove blank lines and state logs
(setq org-agenda-entry-text-exclude-regexps '("^- State.*\n" "^[ \t]*\n"))

;; logging
(setq org-log-done 'time)

;; misc
(setq org-M-RET-may-split-line nil)

;; capture templates
(setq org-capture-templates '(
	("I" "Important" entry
	(file+headline "GTD.org" "Important")
	"* %? %i")
	("i" "Not important" entry
	(file+headline "GTD.org" "Not important")
	"* %? %i")
	("m" "Misc TODO" entry
	(file+headline "GTD.org" "Misc")
	"* TODO %? %i")
))

;; checks if org-notes-dir exists.
;; )

;; key bindings
; global leader
(general-define-key
	:keymaps 'override
	:states '(motion normal visual)
	:prefix "SPC"

)
(general-define-key
	:keymaps 'override
	:states '(motion normal)
	:prefix "SPC"

	"of" '(counsel-org-goto-all ; go to heading of opened org files
		:which-key "org goto all")

	"oc" '(org-capture
		:which-key "org capture")

	"oa" '(org-agenda
		:which-key "org agenda")

	"oi" '(org-pomodoro
		:which-key "org pomo clock in")
)
; org mode leader
(general-define-key
	:keymaps 'org-mode-map
	:states '(motion normal visual)
	:prefix "SPC"

	"jf" '(counsel-org-goto
		:which-key "org goto")
)
(general-define-key
	:keymaps 'org-mode-map
	:states '(motion normal)
	:prefix "SPC"

	"jr" '(org-refile
		:which-key "org refile")

	"jc" '(org-copy
		:which-key "org copy")

	"jt" '(org-todo
		:which-key "org todo")

	"js" '(org-schedule
		:which-key "org schedule")

	"jd" '(org-deadline
		:which-key "org deadline")

	"jp" '(org-priority
		:which-key "org priority")

	"jq" '(org-set-tags-command
		:which-key "org set tags")

	"ji" '(org-pomodoro
		:which-key "org pomo clock in")
)
; org mode
(evil-define-key 'insert org-mode-map (kbd "TAB") 'org-cycle)
(evil-define-key 'insert org-mode-map (kbd "<tab>") 'org-cycle)
(evil-define-key 'normal org-mode-map
  ;; using evil-collection with org mode:
  ;;
  ;; notes:
  ;; can use zc, zo, zO etc.
  ;; many of these are dot-repeatable.
  ;;
  ;; TAB: toggle show or hide, navigate table
  ;; C-TAB: cycle visibility
  ;;
  ;; C-c C-t: make into todo / cycle todo states
  ;; C-c C-s: add / change scheduled start
  ;; C-c C-d: add / change deadline
  ;; C-c C-w: refile (move to)
  ;; C-c ,: add / change priority
  ;; C-c .: enter / modify timestamp (date only)
  ;; C-u C-c .: enter / modify timestamp (with time)
  ;; C-c C-.: enter / modify inactive (no agenda) timestamp (date only)
  ;; C-c C-.: enter / modify inactive (no agenda) timestamp (date only)
  ;;
  ;; C-c C-d: refile (move subtree to)
  ;;
  ;; C-c C-c:
  ;; refresh item under cursor
  ;; toggle state of checkbox
  ;; edit tag of item
  ;;
  ;; C-c [: add current file to agenda file list (DO NOT USE)
  ;;
  ;; C-c c: initiate org capture. can be used everywhere.

  ;; remove bindings
	(kbd "M-h") nil
	(kbd "M-j") nil
	(kbd "M-k") nil
	(kbd "M-l") nil

	(kbd "C-c C-.") 'org-time-stamp-inactive ; with C-u as previx also add time.

	(kbd "C--") 'org-shiftdown ; change date like speed-dating
	(kbd "C-=") 'org-shiftup

	(kbd "C-S-h") 'org-shiftmetaleft ; promote/outdent
	(kbd "C-S-j") 'org-metadown ; move down
	(kbd "C-S-k") 'org-metaup ; move up
	(kbd "C-S-l") 'org-shiftmetaright ; demote/indent
	(kbd "M-h") help-map

	(kbd "M-RET") 'org-insert-heading-respect-content
	(kbd "M-S-RET") 'org-insert-todo-heading-respect-content
	(kbd "C-RET") 'org-insert-subheading
	(kbd "C-S-RET") 'org-insert-todo-subheading
	(kbd "<M-return>") 'org-insert-heading-respect-content
	(kbd "<M-S-return>") 'org-insert-todo-heading-respect-content
	(kbd "<C-return>") 'org-insert-subheading
	(kbd "<C-S-return>") 'org-insert-todo-subheading

	(kbd "C-h") (lambda () (interactive) (outline-hide-subtree))
	(kbd "C-j") 'org-next-visible-heading
	(kbd "C-k") 'org-previous-visible-heading
	;; (kbd "C-l") (lambda () (interactive) (outline-show-entry) (outline-show-children))
	(kbd "C-l") 'org-cycle

	"X" 'outline-show-all
	"Z" 'org-shifttab ; cycle global visibility
)
(evil-define-key 'insert org-mode-map
  ;; using evil-collection with org mode:
  ;;
  ;; M-RET: create heading at same level
  ;; M-S-RET: create TODO heading at same level
  ;; C-RET: create heading at same level below current one (most useful)
  ;; C-S-RET: create TODO heading at same level below current one
  ;;
  ;; TAB and S-TAB: go through table fields
  ;; RET: table next row

	(kbd "C-c C-.") 'org-time-stamp-inactive ; with C-u as previx also add time.

	(kbd "M-RET") 'org-insert-heading-respect-content
	(kbd "M-S-RET") 'org-insert-todo-heading-respect-content
	(kbd "C-RET") 'org-insert-subheading
	(kbd "C-S-RET") 'org-insert-todo-subheading
	(kbd "<M-return>") 'org-insert-heading-respect-content
	(kbd "<M-S-return>") 'org-insert-todo-heading-respect-content
	(kbd "<C-return>") 'org-insert-subheading
	(kbd "<C-S-return>") 'org-insert-todo-subheading

	(kbd "M-h") help-map
)
(evil-define-motion evil-org-next-visible-heading () :type exclusive
	(org-next-visible-heading 1))
(evil-define-motion evil-org-previous-visible-heading () :type exclusive
	(org-previous-visible-heading 1))
(evil-define-key 'visual org-mode-map
	(kbd "C-S-h") (lambda () (interactive) (org-metaleft) (evil-visual-restore)) ; promote/outdent
	(kbd "C-S-l") (lambda () (interactive) (org-metaright) (evil-visual-restore)) ; demote/indent
	(kbd "M-h") help-map

	(kbd "C-j") 'evil-org-next-visible-heading
	(kbd "C-k") 'evil-org-previous-visible-heading
)
(evil-define-key 'motion 'org-mode-map ",,n" 'org-narrow-to-subtree)
; org agenda
(general-define-key
	:keymaps 'org-agenda-mode-map
	:states '(motion normal visual)
	:prefix "SPC"

)
(general-define-key
	:keymaps 'org-agenda-mode-map
	:states '(motion normal)
	:prefix "SPC"

	"jr" '(org-agenda-refile
		:which-key "org agenda refile")

	"jt" '(org-agenda-todo
		:which-key "org agenda todo")

	"js" '(org-agenda-schedule
		:which-key "org agenda schedule")

	"jd" '(org-agenda-deadline
		:which-key "org agenda deadline")

	"jp" '(org-agenda-priority
		:which-key "org agenda priority")

	"jq" '(org-agenda-set-tags
		:which-key "org agenda set tags")

	"ji" '(org-pomodoro
		:which-key "org pomo clock in")
)
(evil-define-key 'motion org-agenda-mode-map
  ;; C-c C-t: make into todo / cycle todo states
  ;; C-c C-s: add / change scheduled start
  ;; C-c C-d: add / change deadline
  ;; C-c ,: add / change priority
  ;;
  ;; .: go to today.
  ;;
  ;; TAB: goto entry.
  ;;
  ;; r: refresh
  ;; q: quit

	"Z" (lambda () (interactive) (when org-agenda-entry-text-mode (org-agenda-entry-text-mode)))
	"X" (lambda () (interactive) (when (not org-agenda-entry-text-mode) (org-agenda-entry-text-mode)))

	(kbd "M-h") help-map

	(kbd "C--") 'org-agenda-do-date-earlier
	(kbd "C-=") 'org-agenda-do-date-later

	(kbd "C-h") 'org-agenda-earlier
	(kbd "C-l") 'org-agenda-later

	"r" 'org-agenda-redo
	"u" (lambda () (interactive) (message "Temporarily disabled undo.")) ; 'org-agenda-undo
	"U" 'org-agenda-redo

	"j" 'org-agenda-next-line
	"j" 'org-agenda-next-line
	"k" 'org-agenda-previous-line
	(kbd "C-j") 'org-agenda-next-date-line
	(kbd "C-k") 'org-agenda-previous-date-line

	(kbd "C-c v") 'org-agenda-view-mode-dispatch
)
