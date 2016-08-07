//
//  SessionDetailViewController.swift
//  iOSDCJP2016
//
//  Created by hayashi311 on 6/12/16.
//  Copyright © 2016 hayashi311. All rights reserved.
//

import UIKit
import AlamofireImage

class SessionDetailViewController: UIViewController, NSLayoutManagerDelegate {
    var session: Session!

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var startAtLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomLabel.attributedText = NSAttributedString(string: session.room.title, style: .Body) {
            builder in
            builder.color = UIColor.colorForRoom(self.session.room)
        }
        
        startAtLabel.attributedText = NSAttributedString(string: session.startAt + "- (\(session.time))", style: .Body) {
            builder in
            builder.color = UIColor.secondaryTextColor()
        }
        
        titleLabel.attributedText = NSAttributedString(string: session.title, style: .Title) {
            builder in
            builder.weight = .Bold
            builder.color = UIColor.darkPrimaryTextColor()
        }
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.layoutMargins = UIEdgeInsetsZero
        descriptionTextView.layoutManager.delegate = self
        descriptionTextView.attributedText = NSAttributedString(string: session.description, style: .Body)
        guard let speaker = session.speaker else { return }
        
        switch speaker.company {
        case let .Some(c):
            companyLabel.attributedText = NSAttributedString(string: c, style: .Small)
        default:
            companyLabel.hidden = true
        }
        
        nameLabel.attributedText = NSAttributedString(string: speaker.name, style: .Title)

        if let image = speaker.image {
            let URL = NSURL(string: APIBaseURL)!.URLByAppendingPathComponent(image)
            
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: iconImageView.frame.size,
                radius: iconImageRadius
            )
            
            iconImageView.af_setImageWithURL(
                URL,
                placeholderImage: nil,
                filter: filter,
                imageTransition: .CrossDissolve(0.2)
            )
        } else {
            iconImageView.image = nil
        }


        header.bounds = CGRect(origin: CGPointZero, size: UIScreen.mainScreen().bounds.size)
        header.setNeedsLayout()
        header.layoutIfNeeded()
        let headerSize = header.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        header.bounds = CGRect(origin: CGPointZero, size: headerSize)
        tableView.tableHeaderView = header
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let navvc = segue.destinationViewController as? UINavigationController else { return }
        
        switch navvc.visibleViewController {
        case let controller as VoteCodeInputViewController:
            controller.nid = session.nid
        default:
            break
        }
    }

    @IBAction func handleVoteButtonTapped(sender: UIBarButtonItem) {
        performSegueWithIdentifier("InputVoteCode", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func unwindFromVoteCodeInputVC(sender: UIStoryboardSegue) {
        print("\(#file).\(#function)")
    }
    
    func layoutManager(layoutManager: NSLayoutManager,
                       lineSpacingAfterGlyphAtIndex glyphIndex: Int,
                       withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return defaultLineHeight
    }
}
