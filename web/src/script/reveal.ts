export function initHeader() {

    const header = document.getElementById("site-header");

    if (!header) return;

    const onScroll = () => {

        if (window.scrollY > 40) {

            header.classList.add("header--scrolled");

        } else {

            header.classList.remove("header--scrolled");

        }

    };

    window.removeEventListener("scroll", onScroll);

    window.addEventListener("scroll", onScroll, {
        passive: true
    });

    onScroll();

}