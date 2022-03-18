pragma circom 2.0.3;


/* 

Strictly forming a Triangle means points aren't exactly the same:

(a0 - b0) + (a1 - b1) != 0
(b0 - c0) + (b1 - c1) != 0
(a0 - c0) + (a1 - c1) != 0

Moreover, strictly forming a Triangle means that hollistically, you can't have more than two points on the same line. This translates as:

if a0 == b0 then b0 != c0
if a0 == c0 then b0 != c0
if c0 == b0 then a0 != c0

the same applies for both axis of coordinates.

if a1 == b1 then b1 != c1
if a1 == c1 then b1 != c1
if c1 == b1 then a1 != c1

let's try as much as possible to intersect these conditions.

*/
function isTriangle(a0, a1, b0, b1, c0, c1) {
    if (a0 == b0) {
        assert(a1 != b1);
        assert(b0 != c0);
    }
    if (b0 == c0) {
        assert(b1 != c1);
        assert(a0 != c0);   
    }
    if (c0 == a0) {
        assert(c1 != a1);
        assert(b0 != c0);
    }
    if (a1 == b1) {
        assert(c1 != a1);
        assert(b0 != a0);
    }
    if (a1 == c1) {
        assert(b1 != c1);
        assert(a0 != c0);
    }
    if (b1 == c1) {
        assert(a1 != c1);
        assert(b0 != c0);
    }
    return 1;
}


function isWithinRange(range, x0, y0, x1, y1) {
    var distance_squared = (x0 - x1)*(x0 - x1) + (y0 - y1)*(y0 - y1);
    assert(distance_squared <= range*range);
    return 1;
}

template TriangleMove() {
    signal input a[2];
    signal input b[2];
    signal input c[2];
    signal input range;
    assert(isTriangle(a[0], a[1], b[0], b[1], c[0], c[1]));
    assert(isWithinRange(range, a[0], a[1], b[0], b[1]));
    assert(isWithinRange(range, b[0], b[1], c[0], c[1]));
    assert(isWithinRange(range, c[0], c[1], a[0], a[1]));
}

component main = TriangleMove();