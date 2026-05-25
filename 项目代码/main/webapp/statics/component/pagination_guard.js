(function () {
    function isPaginationJumperInput(target) {
        if (!target || !target.matches) {
            return false;
        }
        return target.matches(".el-pagination__jump input, .el-pagination__editor input");
    }

    function sanitizePageValue(input) {
        var digits = input.value.replace(/\D/g, "");
        if (input.value !== digits) {
            input.value = digits;
            input.dispatchEvent(new Event("input", {bubbles: true}));
        }
    }

    document.addEventListener("keydown", function (event) {
        if (!isPaginationJumperInput(event.target)) {
            return;
        }
        if (event.key === "e" || event.key === "E" || event.key === "." || event.key === "+" || event.key === "-") {
            event.preventDefault();
        }
    }, true);

    document.addEventListener("beforeinput", function (event) {
        if (!isPaginationJumperInput(event.target) || event.inputType !== "insertText") {
            return;
        }
        if (/\D/.test(event.data || "")) {
            event.preventDefault();
        }
    }, true);

    document.addEventListener("paste", function (event) {
        if (!isPaginationJumperInput(event.target)) {
            return;
        }
        event.preventDefault();
        var text = (event.clipboardData || window.clipboardData).getData("text") || "";
        event.target.value = text.replace(/\D/g, "");
        event.target.dispatchEvent(new Event("input", {bubbles: true}));
    }, true);

    document.addEventListener("input", function (event) {
        if (isPaginationJumperInput(event.target)) {
            sanitizePageValue(event.target);
        }
    }, true);

    document.addEventListener("focusin", function (event) {
        if (!isPaginationJumperInput(event.target)) {
            return;
        }
        event.target.setAttribute("inputmode", "numeric");
        event.target.setAttribute("pattern", "[0-9]*");
    }, true);
})();
