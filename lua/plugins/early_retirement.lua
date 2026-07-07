return {
	"chrisgrieser/nvim-early-retirement",
	event = "VeryLazy",
	opts = {
		ignoreFilenamePattern = "FLUTTER_DEV_LOG",
		ignoredFiletypes = { "log" },
		retirementAgeMins = 10,
		minimumBufferNum = 5,
		ignoreUnsavedChangesBufs = true,
		ignoreVisibleBufs = true,
		ignoreSpecialBuftypes = true,
		ignoreAltFile = true,
		notificationOnAutoClose = true,
		deleteBufferWhenFileDeleted = false,
	},
}
