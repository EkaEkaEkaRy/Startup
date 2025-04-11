from ultralytics.data.converter import convert_coco

convert_coco('./annotations/', use_segments=True, use_keypoints=False, cls91to80=True, save_dir="./result")