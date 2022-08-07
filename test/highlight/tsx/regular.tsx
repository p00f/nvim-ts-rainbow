const abc = {};
// hl       11
// prettier-ignore
function MyComponent() {
    // hl           11 1
    return (
    // hl  2
        <div>
            <span>Hello world</span>
            <img src="self closing" />
        </div>
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
