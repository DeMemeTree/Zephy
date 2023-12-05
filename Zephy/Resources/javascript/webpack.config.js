const path = require('path')

module.exports = {
    target: 'node',
    mode: "production",
    entry: { ZephySDK: "./src/index.ts" },
    output: {
        path:  path.resolve(__dirname, "dist"),
        filename: "[name].bundle.js",
        library: "[name]",
        libraryTarget: "var"
    },
    module: {
        rules: [
          {
            test: /\.ts?$/,
            use: 'ts-loader',
            exclude: /node_modules/,
          },
        ],
    },
    resolve: {
        extensions: ['.tsx', '.ts', '.js'],
        modules: [
          path.resolve('./node_modules')
        ]
    },
};