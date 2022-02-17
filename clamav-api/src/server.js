const NodeClam = require("clamscan");
const express = require("express");
const fileUpload = require("express-fileupload");
const morgan = require("morgan");
const cors = require("cors");

const versionRouter = require("./routes/version");
const scanRouter = require("./routes/scan");

async function makeServer(config) {
  try {
    const newAvConfig = Object.assign({}, config.clamAVConfig);
    const clamscan = await new NodeClam().init(newAvConfig);
    const redirectURL =
      process.env.REDIRECT_URL ||
      "https://github.com/romarcablao/clamav-container-setup#clamav-container-setup";
    const PORT = process.env.APP_PORT || 3000;
    const app = express();

    app.use(cors());

    app.get("/", function (req, res) {
      res.redirect(redirectURL);
    });

    app.use(function (req, res, next) {
      if (req.headers.authorization !== process.env.AUTHTOKEN) {
        return res
          .status(403)
          .json({ success: false, data: { error: "Invalid credentials" } });
      }
      next();
    });

    app.use(fileUpload({ ...config.fileUploadConfig }));

    app.use(function (req, res, next) {
      req._av = clamscan;
      console.log(req.headers);
      if (
        !req.files &&
        req.headers["content-length"] &&
        req.headers["content-length"] !== "0"
      ) {
        let data = new Buffer.from("");
        req.on("data", function (chunk) {
          data = Buffer.concat([data, chunk]);
        });
        req.on("end", function () {
          req.rawBody = data;
          req.files = {
            [process.env.APP_FORM_KEY]: [
              {
                name: `file-${Date.now()}`,
                request: "binary",
                data: req.rawBody,
              },
            ],
          };
          next();
        });
      } else {
        next();
      }
    });

    process.env.NODE_ENV !== "test" &&
      app.use(morgan(process.env.APP_MORGAN_LOG_FORMAT || "combined"));

    app.use("/api/v1/version", versionRouter);

    app.use("/api/v1/scan", scanRouter);

    app.all("*", (req, res, next) => {
      res.status(405).json({ success: false, data: { error: "Not allowed" } });
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
