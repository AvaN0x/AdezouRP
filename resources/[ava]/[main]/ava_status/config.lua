-------------------------------------------
-------- MADE BY GITHUB.COM/AVAN0X --------
--------------- AvaN0x#6348 ---------------
-------------------------------------------
AVAConfig = {}

AVAConfig.Status = json.decode(LoadResourceFile(GetCurrentResourceName(), "status.json") or "{}") or {}

-- Interval in ms
AVAConfig.Interval = 2000
-- In ms
AVAConfig.SaveTimeout = 15 * 1000

