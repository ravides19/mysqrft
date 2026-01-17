# Property Management Portal - Color Palette

This document outlines the Airbnb-inspired color palette configured for the property management portal.

## Overview

The color scheme emphasizes:
- **Airbnb-style red** as the primary brand color
- **Warm wooden/earthy tones** for secondary elements
- **Rich, warm colors** throughout
- **Full dark mode support**

## Primary Colors (Airbnb Red)

### Light Mode
- **Primary**: `#FF385C` - Main brand color (Airbnb red)
- **Primary Hover**: `#E0304A` - Darker red for hover states
- **Primary Border**: `#CC2C47` - For borders and indicators

### Dark Mode
- **Primary**: `#FF6B7A` - Brighter red for better visibility
- **Primary Hover**: `#FF8A96` - Lighter red for hover states
- **Primary Border**: `#FFB4BC` - Light red for borders

## Secondary Colors (Wooden/Warm Brown)

### Light Mode
- **Secondary**: `#8B5A3C` - Rich warm brown
- **Secondary Hover**: `#6B4229` - Darker brown
- **Secondary Border**: `#5A3520` - Deep brown for borders

### Dark Mode
- **Secondary**: `#C4926A` - Lighter warm brown
- **Secondary Hover**: `#D4A378` - Light brown for hover
- **Secondary Border**: `#E8C4A5` - Light brown borders

## Natural Theme (Wooden/Earthy)

### Light Mode
- **Natural**: `#6b5d52` - Medium brown wood tone
- **Natural Hover**: `#4a3e35` - Darker wood tone
- **Natural Background**: `#f5f1ed` - Warm beige background

### Dark Mode
- **Natural**: `#d4c5b8` - Light wood tone
- **Natural Hover**: `#e4d5c8` - Very light wood
- **Natural Background**: `#3e3530` - Dark warm brown

## Dawn Theme (Terracotta/Warm Earth)

### Light Mode
- **Dawn**: `#B8623A` - Rich terracotta
- **Dawn Hover**: `#8B4A2A` - Dark terracotta
- **Dawn Background**: `#FFF5ED` - Warm off-white

### Dark Mode
- **Dawn**: `#E89A6B` - Light terracotta
- **Dawn Hover**: `#F0A680` - Very light terracotta
- **Dawn Background**: `#2E1A0E` - Dark warm earth

## Base Colors (Warm Neutrals)

### Light Mode
- **Background**: `#faf9f7` - Warm off-white
- **Text**: `#1a1a18` - Dark warm gray
- **Border**: `#e5e3e0` - Warm light gray
- **Hover**: `#faf9f7` - Slightly warmer background

### Dark Mode
- **Background**: `#1a1815` - Very dark warm gray
- **Text**: `#faf9f7` - Light warm beige
- **Border**: `#2a2a28` - Medium warm gray
- **Hover**: `#2a2724` - Slightly lighter warm dark

## Shadow Colors

All shadows use 50% opacity:
- **Primary Shadow**: `rgba(255, 56, 92, 0.5)` - Red glow
- **Secondary Shadow**: `rgba(139, 90, 60, 0.5)` - Brown glow
- **Dawn Shadow**: `rgba(184, 98, 58, 0.5)` - Terracotta glow
- **Natural Shadow**: `rgba(107, 93, 82, 0.5)` - Wood tone glow

## Gradient Colors

### Primary Gradients
- **Light**: `#E0304A` → `#FF385C` (darker to lighter red)
- **Dark**: `#FF385C` → `#FFB4BC` (red to light pink)

### Secondary Gradients
- **Light**: `#6B4229` → `#8B5A3C` (dark to medium brown)
- **Dark**: `#C4926A` → `#E8C4A5` (brown to light tan)

### Dawn Gradients
- **Light**: `#8B4A2A` → `#B8623A` (dark to medium terracotta)
- **Dark**: `#E89A6B` → `#F2C5A8` (terracotta to light peach)

## Usage in Components

These colors are available through Mishika Chelekom components:

```heex
<!-- Primary red button -->
<.button color="primary">Book Now</.button>

<!-- Secondary wooden tone card -->
<.card color="secondary" variant="bordered">Property Details</.card>

<!-- Natural wooden background -->
<.card color="natural" variant="default">Natural Wood Tone</.card>

<!-- Terracotta accent -->
<.badge color="dawn">Featured</.badge>
```

## Tailwind CSS Variables

All colors are mapped to Tailwind variables in `assets/css/app.css`:

```css
--color-primary-light: var(--primary-light);  /* #FF385C */
--color-primary-dark: var(--primary-dark);    /* #FF6B7A */
--color-secondary-light: var(--secondary-light);  /* #8B5A3C */
--color-natural-light: var(--natural-light);  /* #6b5d52 */
--color-dawn-light: var(--dawn-light);        /* #B8623A */
```

## Color Configuration

Colors are configured in `priv/mishka_chelekom/config.exs` using the `css_overrides` option with `:merge` strategy, which means:
- Custom colors override defaults
- Unspecified colors keep default values
- Changes require CSS rebuild to take effect

## Rebuilding CSS

After color changes, rebuild assets:
```bash
mix assets.build
# or for development
mix assets.deploy
```

## Design Principles

1. **Warmth**: All colors have warm undertones to create a welcoming, home-like feeling
2. **Contrast**: Sufficient contrast ratios for accessibility in both light and dark modes
3. **Brand Identity**: Primary red matches Airbnb's signature color for familiar, trusted feel
4. **Richness**: Wooden and earthy tones convey luxury and quality
5. **Dark Mode**: All colors have carefully crafted dark mode variants for optimal readability
