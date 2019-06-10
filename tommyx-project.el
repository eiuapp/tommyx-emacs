;; requires
(require 'projectile)

;; general config
(setq compile-command "")

;; configs
(setq projectile-enable-caching t)
(projectile-mode)
; neotree integration
(setq projectile-switch-project-action 'neotree-projectile-action)
(setq projectile-globally-ignored-directories (append '("node_modules" "dist" "bin" "build") projectile-globally-ignored-directories))

;; TODO: temporary bug fix
(setq projectile-project-compilation-cmd "")

;; helper functions
(defun project/project-relative-name ()
	"Return the project-relative file name of 'buffer-file-name'."
	(ignore-errors (file-relative-name
									buffer-file-name (projectile-project-root))))

;; project definitions
(defun project-cp-run ()
  "Return a String representing the compile command to run for the given context."
  (cond
   ((eq major-mode 'c++-mode)
    (concat (if (eq system-type 'windows-nt)
								"cl /EHsc /W4 /out:a.exe \""
								"g++ -Wall -std=c++11 -o a.exe \"")
						(project/project-relative-name)
						"\""))
   ((eq major-mode 'python-mode)
    (concat "python \""
						(project/project-relative-name)
						"\""))
   ))
(projectile-register-project-type 'cp '("cp.txt")
	:compile #'project-cp-run
	:run #'project-cp-run
)

;; key bindings
(global-leader-project-def
	:states '(motion normal)

	"C-f" '(counsel-rg
		:which-key "search in directory")
	(kbd "C-S-F") '((lambda () (interactive) (counsel-rg (selection-or-word-at-point)))
		:which-key "search cursor in directory")
	"f" '(counsel-projectile-rg
		:which-key "search in project")
	"F" '((lambda () (interactive)
          (let ((counsel-projectile-rg-initial-input
                 (selection-or-word-at-point t)))
            (counsel-projectile-rg)))
		:which-key "search cursor in project")
  
	"p" '(counsel-projectile-switch-project
		:which-key "switch project")
	"w" '(persp-switch
		:which-key "switch workspace")
	"n" '(persp-rename
		:which-key "rename workspace")
	"d" '(persp-kill
		:which-key "delete workspace")
	"R" '(projectile-invalidate-cache
		:which-key "re-index project files")

	"r" '(projectile-run-project
		:which-key "run project")
	"c" '(compile
		:which-key "compile")
	"C" '(projectile-compile-project
		:which-key "compile project")
  "C-c" '(kill-compilation
    :which-key "kill compilation")

  "t" '(ansi-term
    :which-key "open terminal")
  "T" '(projectile-run-term
    :which-key "open project terminal")

  "e" '(projectile-run-eshell
    :which-key "open project eshell")

  "s" '(shell-command
    :which-key "shell command")

)
