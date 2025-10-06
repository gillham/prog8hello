;
; Hello World example.
;

%import textio
%zeropage basicsafe

main {
    sub start() {
        txt.lowercase()
        txt.print("Hello, World!\n")
    }
}
