"use strict";

(function () {
    var KEY = "utopia-theme";
    var btn = document.createElement("button");
    btn.type = "button";
    btn.id = "theme-toggle";
    btn.title = "Toggle light / dark mode";
    btn.textContent = "Light Mode";

    function current() {
        return document.documentElement.getAttribute("data-theme") === "light" ? "light" : "dark";
    }

    function apply(theme) {
        document.documentElement.setAttribute("data-theme", theme);
        btn.textContent = theme === "dark" ? "Light Mode" : "Dark Mode";
        try { localStorage.setItem(KEY, theme); } catch (e) {}
    }

    btn.addEventListener("click", function () {
        apply(current() === "dark" ? "light" : "dark");
    });

    document.body.appendChild(btn);
    apply(current());
})();
