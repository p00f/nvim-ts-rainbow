// NOTE: javascript parser should allow JSX

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
