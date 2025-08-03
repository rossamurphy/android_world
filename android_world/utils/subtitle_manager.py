import time
import textwrap
from datetime import timedelta
from pathlib import Path

# This is used in the example, so it's good to have.
import logging

logger = logging.getLogger(__name__)


class SubtitleManager:
    """Handles the creation of SRT subtitle files for video recordings."""

    def __init__(self, output_dir: Path | str, task_name: str, task_idx: int):
        """
        Initializes the manager and notes the start time of the task.
        Accepts the output directory as either a string or a Path object.
        """
        self.start_time = time.monotonic()
        self.entries = []
        self.counter = 1

        # Ensure output_dir is a Path object for robust handling
        output_path = Path(output_dir)
        srt_filename = f"subtitles_{task_name}_{task_idx}.srt"
        self.output_path = output_path / srt_filename

    def _format_time(self, seconds: float) -> str:
        """Converts seconds into SRT timestamp format (HH:MM:SS,ms)."""
        td = timedelta(seconds=seconds)
        total_seconds = int(td.total_seconds())
        hours, remainder = divmod(total_seconds, 3600)
        minutes, seconds = divmod(remainder, 60)
        milliseconds = td.microseconds // 1000
        return f"{hours:02}:{minutes:02}:{seconds:02},{milliseconds:03}"

    def add_entry(self, text: str, duration: int = 4):
        """Adds a new subtitle and adjusts the previous one's end time."""
        now_s = time.monotonic() - self.start_time
        start_ts = self._format_time(now_s)

        # <<< MODIFIED LOGIC >>>
        # If there's a previous entry, cut its duration short so it ends
        # exactly when this new one begins.
        if self.entries:
            last_entry = self.entries[-1]
            # Split the entry into its parts to replace the end time
            parts = last_entry.split(" --> ")
            header = parts[0]  # This is the "1\n00:00:01,234" part
            # Reconstruct the entry with a new end time
            body = parts[1].split("\n", 1)[1]
            self.entries[-1] = f"{header} --> {start_ts}\n{body}"
        # <<< END MODIFIED LOGIC >>>

        # Create the new subtitle entry with its full default duration.
        # It will be cut short later if another entry is added.
        end_seconds = now_s + duration
        end_ts = self._format_time(end_seconds)

        wrapped_text = "\n".join(textwrap.wrap(text, width=40))
        new_entry = f"{self.counter}\n{start_ts} --> {end_ts}\n{wrapped_text}\n"

        self.entries.append(new_entry)
        self.counter += 1
        logger.info(f"SUBTITLE (Dynamic): Added entry @ {start_ts} -> '{text}'")

    def write_file(self):
        """Writes all collected subtitle entries to the .srt file."""
        if not self.entries:
            logger.warn("No subtitle entries were generated.")
            return

        # Use pathlib's method to create the parent directory
        self.output_path.parent.mkdir(parents=True, exist_ok=True)

        # open() works seamlessly with Path objects
        with open(self.output_path, "w", encoding="utf-8") as f:
            f.write("\n".join(self.entries))
        logger.info(f"Subtitles successfully written to {self.output_path}")
