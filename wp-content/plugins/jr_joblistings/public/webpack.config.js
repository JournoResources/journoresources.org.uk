"use strict";

const path = require("path");
const webpack = require("webpack");

const HtmlWebpackPlugin = require("html-webpack-plugin");

const buildPath = __dirname + "/build";

module.exports = {
  entry: "./index.js",

  devServer: {
    contentBase: buildPath,
    port: 3001,
    stats: "errors-only",
    historyApiFallback: {
      disableDotRule: true,
      rewrites: [{ from: /^[^.]*$/, to: "/index.html" }]
    }
  },

  output: {
    path: buildPath
  },

  plugins: [
    new webpack.DefinePlugin({
      "process.env.PUBLIC_URL": "'http://localhost:8000'"
    }),
    
    // Suggested for hot-loading
    new webpack.NamedModulesPlugin(),
    
    // Prevents compilation errors causing the hot loader to lose state
    new webpack.NoEmitOnErrorsPlugin(),
    
    new HtmlWebpackPlugin({
      inject: true,
      template: "partials/index.html"
    })
  ],

  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          { loader: "elm-hot-webpack-loader" },
          {
            loader: "elm-webpack-loader",
            options: {
              forceWatch: true,
              debug: true
            }
          }
        ]
      },
      {
        test: /\.css$/,
        use: ["style-loader", "css-loader", "postcss-loader"]
      }
    ]
  },

  resolve: {
    modules: ["node_modules"],
    extensions: [".js", ".elm"]
  }
};
