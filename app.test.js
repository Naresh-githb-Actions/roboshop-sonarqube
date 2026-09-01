const test = require("node:test");
const assert = require("node:assert");

test("Hello World test", () => {
    const message = "Hello World";

    assert.strictEqual(message, "Hello World");
});