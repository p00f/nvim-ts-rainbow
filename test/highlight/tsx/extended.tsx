const abc = {};
// hl       11

// NOTE: there are syntax errors because of using // as comments in JSX.
// Using {/* */} as comments would lead to the braces being highlighted
// which would require more and more comments

// prettier-ignore
function MyComponent() {
    // hl           11 1
    return (
    // hl  2
        <div>
// hl   33333
            <span>Hello world</span>
    // hl   444444           4444444
            <img src="self closing" />
    // hl   4444                    44
        </div>
//hl    333333
     );
// hl2
     }
// hl1

// prettier-ignore
    (function () {
//hl2         33 3
        const abc = {
        // hl       4
            nested: {
            // hl   5
                evenMore: {
                // hl     6
                    another: [
                    // hl    7
                        {
                    //hl1
                            level: "",
                        },
                    //hl1
                    ],
                //hl7
                },
            //hl6
            },
        //hl5
        };
    //hl4

        class Foo {
            // hl 4
            method() {
            // hl 55 5
                fn()
            // hl 66
            }
        //hl5
        }
    //hl4
    })();
//hl3211
