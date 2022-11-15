
(impl-trait .nft-trait.sip009)

(define-non-fungible-token my-nft uint)

(define-constant mint_price u100)
(define-constant wallet_1 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM) ;; creator
(define-constant wallet_2 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5) ;; artist

;; store the last token-id, it will increment whenever new token is created
(define-data-var last-token-id uint u0)

;; defining a read only function from nft-trait which doesnt taken any parameters.
(define-read-only (get-last-token-id)
 (ok (var-get last-token-id))
)

;; read-only function just reterive data from the blockchain

;; defining uri
;; (define-data-var uri (string-ascii 256) "ipfs://QmdQ6pqBmiYbZydStLavTw66bPMcGN3hEdYYtWqjJn4g7q")

;;now, second function in the nft trait.
(define-read-only (get-token-uri (id uint))
 (ok none)
)

;; defing third function with built in return function 'nft-get-owner'
(define-read-only (get-owner (id uint))
 (ok (nft-get-owner? my-nft id))
)

;; defing public function which is help us to make changes on chain.
(define-public (transfer (id uint) (sender principal) (recipient principal)) 
 (nft-transfer? my-nft id sender recipient)
)

;; if u run clarinet check command to check the code you might get some warnings but no errors.

;; Mint NFT. Not included in the standralized contract but most people want to mint nft right away.

;; first defining variable using let for increasing the token-id to 1 more and portion of total to give to creator and artist 
(define-public (mint (recipient principal)) 
 (let
    (
    (id (+ (var-get last-token-id) u1))
    (portion-of-total (/ mint_price u2))
    )
    
    (try! (stx-transfer? portion-of-total recipient wallet_1) )
    (try! (stx-transfer? portion-of-total recipient wallet_2) )
    (try! (nft-mint? my-nft id recipient))
    (var-set last-token-id id)
    (ok id)
 )
)
