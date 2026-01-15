// If your components require any hooks or custom uploaders, or if your pages
// require connect parameters, uncomment the following lines and declare them as
// such:
//
// import * as Hooks from "./hooks";
// import * as Params from "./params";
// import * as Uploaders from "./uploaders";

// (function () {
//   window.storybook = { Hooks, Params, Uploaders };
// })();


// If your components require alpinejs, you'll need to start
// alpine after the DOM is loaded and pass in an onBeforeElUpdated
// 
// import Alpine from 'alpinejs'
// window.Alpine = Alpine
// document.addEventListener('DOMContentLoaded', () => {
//   window.Alpine.start();
// });

// (function () {
//   window.storybook = {
//     LiveSocketOptions: {
//       dom: {
//         onBeforeElUpdated(from, to) {
//           if (from._x_dataStack) {
//             window.Alpine.clone(from, to)
//           }
//         }
//       }
//     }
//   };
// })();

// Mishka Chelekom components require hooks for interactive components
// like Accordion (Collapsible), Carousel, Combobox, etc.
import MishkaComponents from "../vendor/mishka_components.js";

(function () {
    window.storybook = { Hooks: MishkaComponents };
})();

