# Play Store Graphics Assets Guide

## Overview
This document provides specifications and guidance for creating all required graphics assets for the Google Play Store listing.

## Required Assets

### 1. App Icon (High-Resolution)
**Specification:**
- **Size:** 512 x 512 pixels
- **Format:** PNG (32-bit with alpha channel)
- **Max file size:** 1024 KB
- **Color space:** sRGB
- **Status:** ✓ Available (assets/images/logo.png - resize to 512x512)

**Design Guidelines:**
- Use the existing logo from `assets/images/logo.png`
- Ensure icon is clear and recognizable at small sizes
- Avoid text in the icon (logo/symbol only)
- Use consistent brand colors
- Consider safe area: keep important elements in center 80%
- Icon should work on light and dark backgrounds

**Tools for Resizing:**
- Photoshop: Image > Image Size > 512x512px, save as PNG
- GIMP: Image > Scale Image > 512x512px
- Online: https://www.resizepixel.com/ or https://www.iloveimg.com/resize-image

**Export Settings:**
- No compression
- Maintain alpha channel
- sRGB color profile
- 72 DPI (standard for web)

---

### 2. Feature Graphic
**Specification:**
- **Size:** 1024 x 500 pixels
- **Format:** JPG or PNG (24-bit, no alpha)
- **Max file size:** 1024 KB
- **Aspect ratio:** 2.048:1
- **Status:** ⚠️ NEEDS CREATION

**Design Guidelines:**
- Showcase key features of the app
- Use brand colors (primary: #5D5CDE)
- Include app logo/icon
- Avoid small text (won't be readable in thumbnails)
- Safe area: 924 x 400 pixels (center area)
- No critical elements in outer 50px on sides or 50px on top/bottom

**Content Suggestions:**
```
Layout Option 1 (Horizontal):
- Left: App icon/logo (200x200)
- Center: "AI Legal Assistant" text
- Right: 3 feature icons (case law, AI, statutes)
- Background: Gradient (purple to blue)

Layout Option 2 (Centered):
- Center: App icon/logo with "Pocket Lawyer" text
- Bottom: "8M+ Cases • AI-Powered • 50 States"
- Background: Professional legal imagery (scales, books)
- Overlay: Semi-transparent gradient

Layout Option 3 (Showcase):
- Left: Phone mockup showing app interface
- Right: Key features bullets
  • 8M+ Court Cases
  • AI Legal Analysis
  • Real-time Updates
- Background: Solid brand color with subtle pattern
```

**Color Palette:**
- Primary: #5D5CDE (purple-blue)
- Accent: #4CAF50 (green for success indicators)
- Background: White or light gradient
- Text: Dark gray (#333333) or white

**Tools:**
- Canva (free templates): https://www.canva.com/
- Figma (professional): https://www.figma.com/
- Photoshop/Illustrator
- Online: https://www.crello.com/

**Template Structure:**
```
Width: 1024px
Height: 500px

Safe Zone: 924x400px (centered)
Margins: 50px all sides

Grid:
- 3 columns (341px each, 1px gap)
- 2 rows (250px each)

Typography:
- Heading: 48-72pt, Bold
- Subheading: 24-36pt, Medium
- Body: 18-24pt, Regular
```

---

### 3. Phone Screenshots
**Specification:**
- **Minimum required:** 2
- **Maximum allowed:** 8
- **Recommended size:** 1080 x 1920 pixels (portrait, 9:16)
- **Format:** JPG or PNG (24-bit)
- **Minimum:** 320px shortest side
- **Maximum:** 3840px longest side
- **Status:** ⚠️ NEEDS CREATION

**Required Screenshots (Priority Order):**

**Screenshot 1: Home/Chat Screen**
- Show main interface with AI chat
- Sample query: "What are tenant rights in California?"
- Partial AI response visible
- Clean, intuitive interface
- Highlight: AI-powered analysis

**Screenshot 2: Legal Search Results**
- Show search results with case law
- Multiple cases listed with citations
- Professional layout
- Highlight: Access to 8M+ cases

**Screenshot 3: Document Templates**
- Library of legal document templates
- Categories visible (contracts, forms, etc.)
- Professional icons/thumbnails
- Highlight: Ready-to-use templates

**Screenshot 4: Settings/Profile (with Referral Code)**
- Show referral code prominently
- "Share & Earn" section visible
- Professional status indicators
- Highlight: Earn Pro access

**Screenshot 5: Pro Features**
- Comparison: Free vs Pro
- Feature list
- Pricing information
- Highlight: Unlimited queries

**Screenshot 6: Search Filters**
- Advanced search options
- Jurisdiction selection
- Date range filters
- Highlight: Powerful search

**Screenshot 7: Case Detail View**
- Full case information
- Citations and links
- AI summary
- Highlight: Detailed analysis

**Screenshot 8: Multi-State Coverage**
- Map or list of all 50 states
- State-specific features
- Quick state switcher
- Highlight: Nationwide coverage

**Capture Methods:**

**Option 1: Real Device Screenshots**
```bash
# Run app on device or emulator
flutter run --release

# Take screenshots using:
# Android: Power + Volume Down
# Emulator: Camera icon in controls
```

**Option 2: Automated Screenshots**
```bash
# Install screenshot tool
flutter pub add screenshots

# Configure screenshots.yaml
# Run automated capture
flutter screenshots
```

**Option 3: Mockup Tools**
- Device frames: https://mockuphone.com/
- Screenshot mockups: https://screenshot.rocks/
- App mockup generator: https://www.mockupworld.co/

**Screenshot Framing:**
- Add device frame (optional but recommended)
- Keep status bar clean
- Hide sensitive test data
- Use realistic content
- Consistent time/battery icons across screenshots

**Text Overlays (Optional):**
If adding text overlays to screenshots:
- Font size: 64-96pt
- Position: Top or bottom third
- Background: Semi-transparent overlay for readability
- Keep text concise: 3-5 words max
- Use brand colors

**Example Text Overlays:**
1. "AI-Powered Legal Guidance"
2. "Access 8M+ Court Cases"
3. "Legal Document Templates"
4. "Earn Rewards for Referrals"
5. "Pro Features Unlocked"
6. "Advanced Search Filters"
7. "Detailed Case Analysis"
8. "All 50 States Covered"

---

### 4. Tablet Screenshots (Optional)
**7-inch Tablet:**
- **Recommended size:** 1200 x 1920 pixels
- **Minimum:** 1024px shortest side
- **Format:** JPG or PNG
- **Status:** Optional

**10-inch Tablet:**
- **Recommended size:** 1600 x 2560 pixels
- **Minimum:** 1024px shortest side
- **Format:** JPG or PNG
- **Status:** Optional

**Note:** Tablet screenshots are optional but recommended if app has tablet-optimized layout.

---

### 5. Promo Video (Optional)
**Specification:**
- **Platform:** YouTube only (provide URL)
- **Duration:** 30 seconds to 2 minutes
- **Aspect ratio:** 16:9 (landscape)
- **Recommended:** 1920 x 1080 pixels
- **Status:** Optional (for future update)

**Video Script Template (60 seconds):**
```
[0-10s] Hook
"Need legal help but can't afford a lawyer?"

[10-20s] Problem
"Legal issues are complex, expensive, and time-consuming."

[20-40s] Solution
"Introducing Pocket Lawyer - Your AI Legal Assistant
• Access 8 million court cases
• AI-powered legal analysis
• 50-state coverage
• Free to start"

[40-50s] Demo
Quick app walkthrough (3-4 screens)

[50-60s] Call to Action
"Download Pocket Lawyer today. Get 5 free queries daily!"
[App icon + "Download Now"]
```

**Video Tools:**
- Screen recording: OBS Studio (free)
- Editing: DaVinci Resolve (free), Adobe Premiere
- Animation: After Effects, Lottie
- Stock footage: Pexels, Unsplash (free)

---

## Asset Checklist

### Must Have (Required for Launch)
- [x] App icon 512x512 (available, needs resize)
- [ ] Feature graphic 1024x500
- [ ] Phone screenshot 1 (Home/Chat)
- [ ] Phone screenshot 2 (Search Results)

### Should Have (Highly Recommended)
- [ ] Phone screenshot 3 (Templates)
- [ ] Phone screenshot 4 (Referral)
- [ ] Phone screenshot 5 (Pro Features)
- [ ] Phone screenshot 6 (Search Filters)

### Nice to Have (Optional but Beneficial)
- [ ] Phone screenshot 7 (Case Detail)
- [ ] Phone screenshot 8 (Multi-State)
- [ ] 7-inch tablet screenshots
- [ ] 10-inch tablet screenshots
- [ ] Promo video

---

## Design Principles

### Brand Identity
**Colors:**
- Primary: #5D5CDE (Purple-Blue)
- Secondary: #4CAF50 (Green)
- Accent: #FFC107 (Amber for highlights)
- Background: #FFFFFF (White)
- Text: #333333 (Dark Gray)

**Typography:**
- Primary font: Roboto (Android standard)
- Heading: Bold, 24-48pt
- Body: Regular, 14-18pt
- Captions: Medium, 12-14pt

**Imagery:**
- Professional legal imagery (scales, gavel, books)
- Modern, clean interface screenshots
- Consistent color scheme
- High contrast for readability

### Consistency
- Use same device frame across all screenshots
- Consistent status bar appearance
- Uniform text overlay style (if used)
- Brand colors throughout
- Similar composition and layout

### Quality Standards
- High resolution (2x or 3x for retina displays)
- Sharp, clear images (no blur or pixelation)
- Professional appearance
- Accurate representation of app features
- No misleading or exaggerated claims

---

## Quick Start Guide

### Step 1: Prepare Existing Logo
1. Open `assets/images/logo.png` in image editor
2. Resize to 512x512 pixels
3. Export as PNG with transparency
4. Verify file size < 1024 KB
5. Save as `app-icon-512.png`

### Step 2: Create Feature Graphic
1. Use Canva template or create in Photoshop
2. Dimensions: 1024x500 pixels
3. Include app icon, title, 3 key features
4. Use brand colors (#5D5CDE)
5. Export as JPG or PNG
6. Save as `feature-graphic-1024x500.png`

### Step 3: Capture Screenshots
1. Run app in release mode on device/emulator
2. Navigate to 8 key screens
3. Capture screenshots (Power + Volume Down)
4. Transfer to computer
5. Resize if needed to 1080x1920 (portrait)
6. Add device frames using mockup tool
7. Save as `screenshot-1.png` through `screenshot-8.png`

### Step 4: Review and Upload
1. Review all assets for quality
2. Check file sizes and dimensions
3. Ensure consistency across all graphics
4. Upload to Google Play Console
5. Preview in store listing preview

---

## Resources

### Design Tools (Free)
- **Canva:** https://www.canva.com/ (templates)
- **GIMP:** https://www.gimp.org/ (photo editing)
- **Figma:** https://www.figma.com/ (design tool)
- **Inkscape:** https://inkscape.org/ (vector graphics)

### Device Mockups
- **Mockuphone:** https://mockuphone.com/
- **Smartmockups:** https://smartmockups.com/
- **Screely:** https://www.screely.com/

### Stock Images (Free)
- **Unsplash:** https://unsplash.com/
- **Pexels:** https://www.pexels.com/
- **Pixabay:** https://pixabay.com/

### Icon Libraries
- **Material Icons:** https://fonts.google.com/icons
- **Font Awesome:** https://fontawesome.com/
- **Flaticon:** https://www.flaticon.com/

### Color Tools
- **Coolors:** https://coolors.co/ (palette generator)
- **Adobe Color:** https://color.adobe.com/
- **Material Palette:** https://www.materialpalette.com/

### Screenshot Tools
- **Flutter Screenshots:** https://pub.dev/packages/screenshots
- **Fastlane Screenshots:** https://docs.fastlane.tools/

---

## Examples and Inspiration

### Similar Legal Apps
- LegalZoom
- Rocket Lawyer
- DoNotPay
- JustAnswer Legal

Study their Play Store listings for:
- Screenshot composition
- Feature graphic design
- Text overlay style
- Color schemes

### Best Practices
1. Show actual app interface (not concept designs)
2. Use real content (not lorem ipsum)
3. Highlight unique features
4. Clear call-to-action
5. Professional, trustworthy appearance
6. Consistent branding
7. Readable at small sizes
8. Accurate representation

---

## File Naming Convention

Use consistent naming for easy management:

```
app-icon-512.png
feature-graphic-1024x500.png
screenshot-phone-01-home.png
screenshot-phone-02-search.png
screenshot-phone-03-templates.png
screenshot-phone-04-referral.png
screenshot-phone-05-pro.png
screenshot-phone-06-filters.png
screenshot-phone-07-details.png
screenshot-phone-08-states.png
screenshot-tablet-7-01.png
screenshot-tablet-10-01.png
```

---

## Validation Checklist

Before uploading to Play Console:

**App Icon (512x512)**
- [ ] Exactly 512 x 512 pixels
- [ ] PNG format with transparency
- [ ] File size < 1024 KB
- [ ] Clear and recognizable
- [ ] Works on light and dark backgrounds

**Feature Graphic (1024x500)**
- [ ] Exactly 1024 x 500 pixels
- [ ] JPG or PNG (no transparency)
- [ ] File size < 1024 KB
- [ ] Text readable in thumbnail
- [ ] Brand colors used
- [ ] No critical elements in unsafe areas

**Phone Screenshots**
- [ ] At least 2 screenshots
- [ ] Consistent dimensions (recommend 1080x1920)
- [ ] Clear, high-resolution
- [ ] Show real app features
- [ ] Consistent device frame/style
- [ ] Professional appearance
- [ ] Accurate representation

---

## Support

For graphics asset questions:
- Review Google Play asset guidelines: https://support.google.com/googleplay/android-developer/answer/9866151
- Figma community templates: Search "Play Store assets"
- Contact: design@pocketlawyer.ai (if you have design team)

---

**Note:** Graphics assets are crucial for conversion rates. High-quality, professional graphics can significantly impact download numbers. Allocate sufficient time and resources to create compelling visuals.
