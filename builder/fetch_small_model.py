from concurrent.futures import ThreadPoolExecutor
from faster_whisper import WhisperModel

model_name = "small"


WhisperModel(model_name, device="cpu", compute_type="int8")

