var example = require("./build/Release/example");

// First create some objects using the pointer library.
console.log("Testing the pointer library");
var a = example.new_intp();
var b = example.new_intp();
var c = example.new_intp();

example.intp_assign(a,37);
example.intp_assign(b,42);

console.log(" a = " + example.intp_value(a));
console.log(" b = " + example.intp_value(b));
console.log(" c = " + example.intp_value(c));

//// Call the add() function with some pointers
example.add(a, b, c);

//
//// Now get the result
var r = example.intp_value(c);
console.log(" 37 + 42 = " + r);

// Clean up the pointers
example.delete_intp(a);
example.delete_intp(b);
example.delete_intp(c);

//// Now try the typemap library
//// This should be much easier. Now how it is no longer
//// necessary to manufacture pointers.
//"OUTPUT" Mapping is not supported
console.log("Trying the typemap library");
r = example.subtract(37.0,42.0);
console.log("37.0 - 42.0 = " + r);

r = example.divide(37,42);
console.log('divide(37,42) returns ' + r)
var a=37,b=42;
r = example.subtract(a,b);
console.log(r[0]);

var a = [1.0,2.0,3.0,4.0],b = [1,1,1,1];
example.aaa = a;
//example.bbb = b;
//var dot = example.opt(a.length,example.aaa,example.bbb);
//console.log(dot);