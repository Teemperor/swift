// RUN: %target-swift-frontend -sil-verify-all -emit-sil %s -o /dev/null -verify

// The circular-inlining failure path in MandatoryInlining used to tear down
// a function's nested pass invocation without first completing any
// lifetimes/infinite-loop fixups deferred earlier while processing that
// function (here, by the `for` loop below), hitting the assertion in
// SwiftPassInvocation::finishedFunctionPassRun ("didn't complete
// lifetimes") instead of just diagnosing the circular inline.

@_transparent
func fibonacci(_ n: Int) -> Int {
    if n <= 1 {
        return n
    }
    return fibonacci(n - 1) + fibonacci(n - 2) // expected-error 2 {{inlining 'transparent' functions forms circular loop}}
}

_ = fibonacci(3) // expected-note {{while inlining here}}
for _ in 0..<0 {
}
