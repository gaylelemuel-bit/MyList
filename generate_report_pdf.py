from pathlib import Path

from bs4 import BeautifulSoup
from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER
from reportlab.lib.pagesizes import letter
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import inch
from reportlab.platypus import (
    KeepTogether,
    ListFlowable,
    ListItem,
    Paragraph,
    Preformatted,
    SimpleDocTemplate,
    Spacer,
)


source = Path("MyList_Project_Report.html")
destination = Path("MyList_Project_Report.pdf")
soup = BeautifulSoup(source.read_text(encoding="utf-8"), "html.parser")

styles = getSampleStyleSheet()
title_style = ParagraphStyle(
    "ReportTitle",
    parent=styles["Title"],
    fontName="Helvetica-Bold",
    fontSize=24,
    leading=29,
    textColor=colors.HexColor("#123B5D"),
    alignment=TA_CENTER,
    spaceAfter=6,
)
subtitle_style = ParagraphStyle(
    "Subtitle",
    parent=styles["Normal"],
    fontSize=11,
    leading=14,
    textColor=colors.HexColor("#526675"),
    alignment=TA_CENTER,
    spaceAfter=20,
)
heading_style = ParagraphStyle(
    "SectionHeading",
    parent=styles["Heading2"],
    fontName="Helvetica-Bold",
    fontSize=14,
    leading=18,
    textColor=colors.HexColor("#155E75"),
    spaceBefore=14,
    spaceAfter=6,
    keepWithNext=True,
)
body_style = ParagraphStyle(
    "ReportBody",
    parent=styles["BodyText"],
    fontName="Helvetica",
    fontSize=10.2,
    leading=14.5,
    textColor=colors.HexColor("#1F2933"),
    spaceAfter=7,
)
info_style = ParagraphStyle(
    "StudentInfo",
    parent=body_style,
    leftIndent=12,
    rightIndent=12,
    spaceAfter=4,
)
code_style = ParagraphStyle(
    "Code",
    parent=styles["Code"],
    fontName="Courier",
    fontSize=8.5,
    leading=11,
    leftIndent=10,
    rightIndent=10,
    spaceBefore=3,
    spaceAfter=9,
    backColor=colors.HexColor("#EEF3F6"),
    borderColor=colors.HexColor("#2F8198"),
    borderWidth=0.6,
    borderPadding=7,
)


def markup(element):
    return element.decode_contents().replace("<code>", "<font name='Courier'>").replace("</code>", "</font>")


story = []
for element in soup.body.find_all(recursive=False):
    if element.name == "h1":
        story.append(Paragraph(markup(element), title_style))
    elif element.name == "h2":
        story.append(Paragraph(markup(element), heading_style))
    elif element.name == "p":
        style = subtitle_style if "subtitle" in element.get("class", []) else body_style
        if "footer-note" not in element.get("class", []):
            story.append(Paragraph(markup(element), style))
    elif element.name == "div" and "student" in element.get("class", []):
        info = [Paragraph(markup(paragraph), info_style) for paragraph in element.find_all("p", recursive=False)]
        story.append(KeepTogether(info))
        story.append(Spacer(1, 10))
    elif element.name == "ul":
        items = [ListItem(Paragraph(markup(item), body_style)) for item in element.find_all("li", recursive=False)]
        story.append(ListFlowable(items, bulletType="bullet", leftIndent=22, bulletFontName="Helvetica", bulletFontSize=8))
        story.append(Spacer(1, 4))
    elif element.name == "pre":
        story.append(Preformatted(element.get_text(), code_style))


def add_page_number(canvas, document):
    canvas.saveState()
    canvas.setFont("Helvetica", 8)
    canvas.setFillColor(colors.HexColor("#667985"))
    canvas.drawCentredString(letter[0] / 2, 0.42 * inch, f"MyList App Development Report  |  Page {document.page}")
    canvas.restoreState()


document = SimpleDocTemplate(
    str(destination),
    pagesize=letter,
    rightMargin=0.78 * inch,
    leftMargin=0.78 * inch,
    topMargin=0.72 * inch,
    bottomMargin=0.65 * inch,
    title="MyList App Development Report",
    author="Student",
)
document.build(story, onFirstPage=add_page_number, onLaterPages=add_page_number)
print(destination.resolve())
