const String economicCalendarHtml = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Economic Calendar</title>
</head>
<body>

    <!-- TradingView Widget BEGIN -->
    <div class="tradingview-widget-container">
        <div id="economicCalendar"></div>
        <script
            type="text/javascript"
            src="https://s3.tradingview.com/external-embedding/embed-widget-events.js"
            async>
        {
            "colorTheme"; "light",
            "isTransparent"; false,
            "width"; "100%",
            "height"; "600",
            "locale"; "en"
        }
        </script>
    </div>
    <!-- TradingView Widget END -->

</body>
</html>

''';
