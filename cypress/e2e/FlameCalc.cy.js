 
describe('Flame Calculator', () => {
  it('Checks the flames score of an item', () => {
    // Visit the website
    cy.visit('https://brendonmay.github.io/flameCalculator/');
    // Wait for the checkbox to be visible and clickable
    cy.get('input[id="flamescorecheck"]').click();
    cy.wait(2000);
    cy.get('.ml-2 > span').click();
    cy.get('#main_flame').click().clear().type('66');
    cy.get('#att_flame').click().clear().type('6');
    cy.get('#all_flame').click().clear().type('6');
    cy.get('#flameButton').click();
    cy.wait(500);
    // Capture text from an element and save it to a file
    cy.get('#flamescore_div').invoke('text').then(text => {
    cy.writeFile('result.txt', text.trim());
    });
  });
});
