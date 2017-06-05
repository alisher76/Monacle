


import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet var textLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
            TwitterClient.sharedInstance?.login(success: {
                print("Logged In")
                self.dismiss(animated: true, completion: {
                    
                })
            }) { (error) in
                print(error)
            }
        
    }
    
}


