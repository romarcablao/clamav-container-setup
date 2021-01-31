const NodeClam = require("clamscan");
const cors = require("cors");
const express = require("express");
const morgan = require("morgan");
const fileUpload = require("express-fileupload");
const versionRouter = require("./routes/version");
const scanRouter = require("./routes/scan");

async function makeServer(cfg) {
  try {
    const newAvConfig = Object.assign({}, cfg.clamAVConfig);
    const clamscan = await new NodeClam().init(newAvConfig);
    const PORT = process.env.APP_PORT || 3000;
    const app = express();

    app.use(cors());

    app.use((req, res, next) => {
      req._av = clamscan;
      next();
    });

    app.use(function (req, res, next) {
      if (req.headers.authorization !== process.env.AUTHTOKEN) {
        return res
          .status(403)
          .json({ success: false, data: { error: "Invalid credentials." } });
      }
      next();
    });

    app.use(fileUpload({ ...cfg.fileUploadConfig }));
    process.env.NODE_ENV !== "test" &&
      app.use(morgan(process.env.APP_MORGAN_LOG_FORMAT || "combined"));

    app.use("/api/v1/version", versionRouter);

    app.use("/api/v1/scan", scanRouter);

    app.all("*", (req, res, next) => {
      res.status(405).json({ success: false, data: { error: "Not allowed." } });
    });

    const srv = app.listen(PORT, () => {
      process.env.NODE_ENV !== "test" &&
        console.log(`Server started on PORT: ${PORT}`);
    });

    return srv;
  } catch (error) {
    console.log(`Cannot initialize clamav object: ${error}`);
    setTimeout(() => {}, 10000);
  }
}

module.exports = { makeServer };
