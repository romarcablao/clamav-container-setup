const express = require("express");
const router = express.Router();

router.route("/").get(async (req, res, next) => {
  try {
    const vers = await req._av.get_version();
    res.json({ success: true, data: { version: vers } });
  } catch (err) {
    res.status(500).json({ success: false, data: { error: err } });
  }
});

module.exports = router;
