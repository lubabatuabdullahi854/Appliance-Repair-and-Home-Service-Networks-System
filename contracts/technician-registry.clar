;; Technician Registry Contract
;; Manages technician certification and specialized equipment training

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-TECHNICIAN-EXISTS (err u101))
(define-constant ERR-TECHNICIAN-NOT-FOUND (err u102))
(define-constant ERR-INVALID-INPUT (err u103))
(define-constant ERR-INVALID-RATING (err u104))

;; Contract owner
(define-constant CONTRACT-OWNER tx-sender)

;; Data structures
(define-map technicians
  { technician-id: uint }
  {
    name: (string-ascii 100),
    skills: (string-ascii 200),
    certifications: (string-ascii 300),
    rating: uint,
    total-jobs: uint,
    is-active: bool,
    registered-at: uint
  }
)

(define-map technician-availability
  { technician-id: uint }
  {
    available: bool,
    next-available: uint,
    max-daily-jobs: uint,
    current-jobs: uint
  }
)

;; Data variables
(define-data-var next-technician-id uint u1)

;; Public functions

;; Register a new technician
(define-public (register-technician (name (string-ascii 100)) (skills (string-ascii 200)) (certifications (string-ascii 300)))
  (let ((technician-id (var-get next-technician-id)))
    (asserts! (> (len name) u0) ERR-INVALID-INPUT)
    (asserts! (> (len skills) u0) ERR-INVALID-INPUT)
    (asserts! (is-none (map-get? technicians { technician-id: technician-id })) ERR-TECHNICIAN-EXISTS)

    (map-set technicians
      { technician-id: technician-id }
      {
        name: name,
        skills: skills,
        certifications: certifications,
        rating: u0,
        total-jobs: u0,
        is-active: true,
        registered-at: block-height
      }
    )

    (map-set technician-availability
      { technician-id: technician-id }
      {
        available: true,
        next-available: block-height,
        max-daily-jobs: u5,
        current-jobs: u0
      }
    )

    (var-set next-technician-id (+ technician-id u1))
    (ok technician-id)
  )
)

;; Update technician skills and certifications
(define-public (update-technician-skills (technician-id uint) (skills (string-ascii 200)) (certifications (string-ascii 300)))
  (let ((technician (unwrap! (map-get? technicians { technician-id: technician-id }) ERR-TECHNICIAN-NOT-FOUND)))
    (asserts! (> (len skills) u0) ERR-INVALID-INPUT)

    (map-set technicians
      { technician-id: technician-id }
      (merge technician { skills: skills, certifications: certifications })
    )
    (ok true)
  )
)

;; Update technician rating after job completion
(define-public (update-technician-rating (technician-id uint) (new-rating uint))
  (let ((technician (unwrap! (map-get? technicians { technician-id: technician-id }) ERR-TECHNICIAN-NOT-FOUND)))
    (asserts! (and (>= new-rating u1) (<= new-rating u5)) ERR-INVALID-RATING)

    (let ((current-rating (get rating technician))
          (total-jobs (get total-jobs technician))
          (updated-rating (if (is-eq total-jobs u0)
                            new-rating
                            (/ (+ (* current-rating total-jobs) new-rating) (+ total-jobs u1)))))

      (map-set technicians
        { technician-id: technician-id }
        (merge technician {
          rating: updated-rating,
          total-jobs: (+ total-jobs u1)
        })
      )
      (ok updated-rating)
    )
  )
)

;; Set technician availability
(define-public (set-availability (technician-id uint) (available bool) (next-available uint))
  (let ((availability (unwrap! (map-get? technician-availability { technician-id: technician-id }) ERR-TECHNICIAN-NOT-FOUND)))
    (map-set technician-availability
      { technician-id: technician-id }
      (merge availability {
        available: available,
        next-available: next-available
      })
    )
    (ok true)
  )
)

;; Deactivate technician
(define-public (deactivate-technician (technician-id uint))
  (let ((technician (unwrap! (map-get? technicians { technician-id: technician-id }) ERR-TECHNICIAN-NOT-FOUND)))
    (asserts! (or (is-eq tx-sender CONTRACT-OWNER) (is-eq tx-sender (as-contract tx-sender))) ERR-NOT-AUTHORIZED)

    (map-set technicians
      { technician-id: technician-id }
      (merge technician { is-active: false })
    )
    (ok true)
  )
)

;; Read-only functions

;; Get technician details
(define-read-only (get-technician (technician-id uint))
  (map-get? technicians { technician-id: technician-id })
)

;; Get technician availability
(define-read-only (get-technician-availability (technician-id uint))
  (map-get? technician-availability { technician-id: technician-id })
)

;; Check if technician is available
(define-read-only (is-technician-available (technician-id uint))
  (match (map-get? technician-availability { technician-id: technician-id })
    availability (and (get available availability) (< (get current-jobs availability) (get max-daily-jobs availability)))
    false
  )
)

;; Get next technician ID
(define-read-only (get-next-technician-id)
  (var-get next-technician-id)
)
