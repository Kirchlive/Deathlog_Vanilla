# Deathlog for Vanilla WoW

A death heatmap addon for Vanilla WoW (1.12) that displays player death locations on the world map, helping you identify dangerous areas.

![Heatmap Example](https://i.imgur.com/example.png)

## Features

- **Death Heatmap Overlay**: Visual heat map showing death density on the world map
- **Real-time Danger Indicator**: Color-coded indicator showing current location danger level
- **High Resolution**: 100x100 grid with Gaussian blur for smooth visualization
- **96,000+ Death Records**: Comprehensive death data from WoW Classic
- **Movable UI**: Shift + Left-click to reposition the danger indicator

## Installation

1. Download or clone this repository
2. Copy the `Deathlog_Vanilla` folder to your `WoW/Interface/AddOns/` directory
3. Restart WoW or type `/reload`

```
WoW/
└── Interface/
    └── AddOns/
        └── Deathlog_Vanilla/
            ├── Deathlog_Vanilla.toc
            ├── Deathlog.lua
            ├── HeatmapRenderer.lua
            ├── DataLoader.lua
            └── Data/
                ├── heatmap.lua
                └── zone_ids.lua
```

## Usage

### Slash Commands

| Command | Description |
|---------|-------------|
| `/deathlog` or `/dl` | Toggle danger indicator visibility |
| `/heatmap` or `/hm` | Toggle heatmap overlay on world map |

### Danger Indicator Colors

| Color | Danger Level |
|-------|--------------|
| Green | Safe |
| Yellow | Caution |
| Orange | Dangerous |
| Red | VERY DANGEROUS |

### Controls

- **Shift + Left Mouse**: Drag to move the danger indicator
- **Open World Map**: Heatmap overlay appears automatically

## Screenshots

### Heatmap on World Map
The heatmap shows death density with a color gradient from yellow (few deaths) to red (many deaths). The overlapping grid creates a fine mesh pattern for better visibility.

### Danger Indicator
A small colored box at the top of your screen indicates the danger level of your current location in real-time.

## Data

This addon includes death data from approximately **96,000 player deaths** across all Vanilla WoW zones, including:

- All Eastern Kingdoms zones
- All Kalimdor zones
- Major dungeons (Deadmines, Wailing Caverns, Shadowfang Keep, etc.)

### Covered Zones

| Eastern Kingdoms | Kalimdor |
|-----------------|----------|
| Elwynn Forest | Durotar |
| Westfall | Mulgore |
| Duskwood | The Barrens |
| Redridge Mountains | Darkshore |
| Stranglethorn Vale | Ashenvale |
| Hillsbrad Foothills | Thousand Needles |
| Arathi Highlands | Tanaris |
| And many more... | And many more... |

## Technical Details

- **Grid Resolution**: 100x100 cells per zone
- **Smoothing**: Gaussian blur (3x3 kernel) for smooth transitions
- **Color Calculation**: Dynamic intensity-based coloring
- **Compatible**: WoW 1.12.x (Vanilla)

## Changelog

### Version 1.0
- Initial release
- 100x100 high-resolution heatmap grid
- Gaussian blur smoothing
- Real-time danger indicator
- Movable indicator (Shift + drag)
- 50 zones with death data
- ~96,000 death records

## Credits & Acknowledgments

This addon is a port/conversion of death data and concepts from two excellent projects:

### [Deathlog by aaronma37](https://github.com/aaronma37/Deathlog)
The original Deathlog addon for WoW Classic (1.13+) which collects and displays player death data with beautiful heatmap visualizations. The death data and heatmap rendering concepts were adapted from this project.

### [RipMap by DaniilSokolyuk](https://github.com/DaniilSokolyuk/RipMap)
A death heatmap addon for Vanilla WoW that provided the foundation for the 1.12-compatible implementation and danger indicator system.

**Thank you to both authors for their excellent work!**

## License

This project is provided as-is for educational and entertainment purposes.
Original projects are under their respective licenses (GPL-3.0 for Deathlog).
