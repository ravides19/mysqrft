// Mishka Chelekom components require hooks for interactive components
// like Accordion (Collapsible), Carousel, Combobox, etc.
import MishkaComponents from "../vendor/mishka_components.js";

(function () {
    window.storybook = { Hooks: MishkaComponents };
})();
