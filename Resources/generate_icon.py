from PIL import Image, ImageDraw, ImageFont
import os

base_dir = os.path.dirname(os.path.abspath(__file__))
iconset_dir = os.path.join(base_dir, "AppIcon.iconset")
os.makedirs(iconset_dir, exist_ok=True)

sizes = [
    (16, 16), (32, 32),
    (32, 32), (64, 64),
    (128, 128), (256, 256),
    (256, 256), (512, 512),
    (512, 512), (1024, 1024)
]
names = [
    "icon_16x16.png", "icon_16x16@2x.png",
    "icon_32x32.png", "icon_32x32@2x.png",
    "icon_128x128.png", "icon_128x128@2x.png",
    "icon_256x256.png", "icon_256x256@2x.png",
    "icon_512x512.png", "icon_512x512@2x.png"
]

def create_icon(size):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Rounded rectangle background
    radius = size // 6
    margin = size // 16
    draw.rounded_rectangle(
        [margin, margin, size - margin, size - margin],
        radius=radius,
        fill=(0, 122, 255, 255)
    )

    # Mosaic grid pattern
    grid_count = 4
    cell = (size - 2 * margin - 2 * radius) // grid_count
    start = margin + radius
    colors = [
        (255, 255, 255, 180),
        (255, 255, 255, 120),
        (255, 255, 255, 160),
        (255, 255, 255, 100),
        (255, 255, 255, 140),
        (255, 255, 255, 200),
        (255, 255, 255, 110),
        (255, 255, 255, 170),
        (255, 255, 255, 130),
        (255, 255, 255, 190),
        (255, 255, 255, 105),
        (255, 255, 255, 150),
        (255, 255, 255, 185),
        (255, 255, 255, 115),
        (255, 255, 255, 165),
        (255, 255, 255, 135),
    ]
    for i in range(grid_count):
        for j in range(grid_count):
            x = start + i * cell
            y = start + j * cell
            idx = i * grid_count + j
            draw.rectangle([x, y, x + cell - 2, y + cell - 2], fill=colors[idx])

    return img

for name, (w, h) in zip(names, sizes):
    icon = create_icon(w)
    icon.save(os.path.join(iconset_dir, name))

print("Iconset generated at", iconset_dir)
